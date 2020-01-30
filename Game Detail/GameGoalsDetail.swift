//
//  GameGoalsDetail.swift
//  Game Detail
//
//  Created by Andy Walters on 12/12/19.
//  Copyright © 2019 Andy Walt. All rights reserved.
//

import SwiftUI
import Combine

struct GameGoalsDetail: View {
    @Environment(\.managedObjectContext) var moc
    
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    
    @State private var showingAddGoal = false
        
    @ObservedObject var game: Game
    
    @ObservedObject var model: EditViewModel
    
    @State private var goalGrow = false
    
    @State var showingEdit: Bool = false
    
    // I don't like their solution. Flipping a @State bool feela like a bit of an antipattern to me
    // Since you're using a publisher anyway, lets use Combine :)
    private var didSave = NotificationCenter.default.publisher(for: .NSManagedObjectContextDidSave)

    // The subscription (Combine terminology for an active connection between two objects) needs to be stored somewhere otherwise ARC (Automatic Reference Counting) will trash it to save memory. Putting it into this set means its held somewhere and we can keep receiving values
    private var cancellables = Set<AnyCancellable>()
    
    init(game: Game) {
        self.game = game
        self.model = EditViewModel(game: game)
        
        // Publishers won't actually publish values unless there's a subscriber demanding them.
        // sink is a subscriber. Here we are saying "When this class is initialised, make a sink subscriber which subscribes to the didSave publisher"
        // Here we don't actually care what the notification is telling us about the save operation, we just care that it happened. So we can drop the value in the trailing closure and just use _ in and use it as a trigger.
        didSave.sink { _ in
            // When this closure is triggered by a notification arriving in the sink, we send a ping to game's objectWillChange property (another publisher!). This triggers game to tell the view to refresh.
            game.objectWillChange.send()
        }
            // store this subscription in the cancellables set to make sure it can hang around as long as this struct exists
    .store(in: &cancellables)
    
    }

    /* Will add some general tips too*/
    var body: some View {
            VStack {
                Section {
                    // Show game info unless being edited
                    if !self.model.showingEdit {
                        Text(self.game.gameName ?? "Unknown Game").font(Font.custom("PressStart2p", size: 20))
                        .foregroundColor(Color.gold)
                        Text(self.game.gameDescription ?? "No Game Description")
                            .font(Font.custom("ChalkboardSE-Light", size: 15))
                            .foregroundColor(Color.gold)
                    } else {
                        EditGameView(model: EditViewModel(game: game))
                    }
                    // Edit Game Info Button
                    Button(action: {
                        self.model.showingEdit.toggle()
                    }) {
                        Text("Edit Game Info")
                        .font(.caption)
                        .foregroundColor(Color.gold)
                        .underline()
                        /* Took this out because it wasn't working properly and was making the UI buggy.
                        if self.model.showingEdit == false {
                            Text("Edit Game Info")
                                .font(.caption)
                                .foregroundColor(Color.gold)
                                .underline()
                        } else {} */
                    }
                }.sheet(isPresented: self.$showingAddGoal) {
                AddGoalsView(game: self.game)
                    .environment(\.managedObjectContext, self.moc)
                    .environment(\.colorScheme, .dark)
                }
                // If there are no goals, show add goal instructions, if not show the goals.
                if !self.game.goalArray.isEmpty {
                    Section {
                        List {
                            ForEach(game.goalArray, id: \.self) { goal in
                                    GameGoalListView(goal: goal)
                                    }
                                    .onDelete { index in
                                        let deleteGoal = self.game.goalArray[index.first ?? 0] // <- this is a trap! If first reveals nil here it means the index array is empty. If you tell it "Give me the value from index 0 what you're telling it is "Delete the first Goal on the list, even if its not the one the user swiped on. It's tricky because you're working with two arrays in one expression there, goalArray is (obviously) an array, but index is another array, an array of 'pointers' to values within the other array, goalArray.
                                        
                                        // This should never be nil, as onDelete would never give you an empty index array. You could force unwrap here, but if you prefer to explicitely unwrap this safely without a trap you could try
                                        // guard let deleteGoal = self.game.goalArray[index.first] else { return }
                                        self.moc.delete(deleteGoal)
                                        
                                        do {
                                            try self.moc.save()
                                        } catch {
                                            print(error)
                                        }
                                    }
                            }
                        
                        .listRowBackground(self.colorScheme == .dark ? Color.black : .none)
                        }
                } else {
                    // Instructions for adding a goal.
                    VStack(alignment: .center) {
                        Text("Adventures await, traveler! To begin accomplishing all the things and stuff, tap the \"Add Goal\" button below and we shall begin doing the things!").onTapGesture {
                            self.showingAddGoal.toggle()
                        }
                        .font(Font.custom("PressStart2p", size: 12))
                        .foregroundColor(Color.gold)
                        .padding(.top, 50)
                        .padding(.horizontal, 40)
                        .multilineTextAlignment(.center)
                        .lineSpacing(10)
                        .scaleEffect(goalGrow ? 1 : 0.5)
                            .animation(.linear(duration: 1))
                        .onAppear() {
                            self.goalGrow.toggle()
                        }
                        List {
                            Text("")
                            
                        }
                    }
                }
                
                // Add New Goal Button
                Button(action: {
                    self.showingAddGoal.toggle()
                }) {
                    HStack {
                        Image(systemName: "plus")
                        Text("Add Goal")
                    }
                    .padding(10)
                    .background(LinearGradient(gradient: Gradient(colors: [Color.gold, Color.yellow, Color.gold]), startPoint: .top, endPoint: .bottom))
                    .cornerRadius(5.0)
                    .foregroundColor(Color.black)
                }
                
        }
        /*
        func reloadGoals() {
            @FetchRequest(entity: Game.entity(), sortDescriptors: []) var games: FetchedResults<Game>
        }
 
        */
        // I took this off because it was preventing me from editing the Game Info.
        //.environment(\.editMode, .constant(self.model.showingEdit ? EditMode.active : EditMode.inactive))
    }
}



struct GameGoalsDetail_Previews: PreviewProvider {
    static var previews: some View {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let newGame = Game.init(context: context)
        newGame.gameName = "Testy Game"
        newGame.gameDescription = "Wooo play the thing"
        
        let goal = Goal(context: context)
        goal.goalName = "Try Harder"
        goal.goalComplete = false
        goal.goalCreatedDate = Date()
        goal.goalDifficulty = "Meh"
        goal.goalOfGame = newGame
        
        return GameGoalsDetail(game: newGame).environment(\.managedObjectContext, context)
            .environment(\.colorScheme, .dark)
    }
}
