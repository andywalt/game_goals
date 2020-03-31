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
    
    private var didSave = NotificationCenter.default.publisher(for: .NSManagedObjectContextDidSave)
    
    private var cancellables = Set<AnyCancellable>()

    
    init(game: Game) {
        self.game = game
        self.model = EditViewModel(game: game)
        
        didSave.sink { _ in
                game.objectWillChange.send()
            }
            
    .store(in: &cancellables)
    
    
    }

    
    var body: some View {
            VStack {
                Section {
                    // Show game info unless being edited
                    if !self.model.showingEdit {
                        Text(self.game.gameName ?? "Unknown Game").font(Font.custom("PressStart2p", size: 20))
                        .foregroundColor(Color.gold)
                        Text(self.game.gameGenre ?? "No Game Genre")
                            .font(Font.custom("ChalkboardSE-Light", size: 15))
                            .foregroundColor(Color.gold)
                        Text(self.game.gamePlatform ?? "No Game Platform")
                            .font(Font.custom("ChalkboardSE-Light", size: 15))
                            .foregroundColor(Color.gold)
                    } else {
                        EditGameView(model: EditViewModel(game: game))
                    }
                    // Edit Game Info Button
                    Button(action: {
                        self.model.showingEdit.toggle()
                    }) {
                        /*
                        Text("Edit Game Info")
                        .font(.caption)
                        .foregroundColor(Color.gold)
                        .underline() */
                        
                        if self.model.showingEdit == false {
                            Text("Edit Game Info")
                                .font(.caption)
                                .foregroundColor(Color.gold)
                                .underline()
                        } else {}
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
                                        let deleteGoal = self.game.goalArray[index.first!]
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
    }
}



struct GameGoalsDetail_Previews: PreviewProvider {
    static var previews: some View {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let newGame = Game.init(context: context)
        newGame.gameName = "Testy Game"
        newGame.gameGenre = "Wooo play the thing"
        newGame.gamePlatform = "Xbox 360"
        
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
