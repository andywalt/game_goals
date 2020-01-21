//
//  GameGoalsDetail.swift
//  Game Detail
//
//  Created by Andy Walters on 12/12/19.
//  Copyright © 2019 Andy Walt. All rights reserved.
//

import SwiftUI


struct GameGoalsDetail: View {
    @Environment(\.managedObjectContext) var moc
    
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    
    @State private var showingAddGoal = false
        
    @ObservedObject var game: Game
    
    @ObservedObject var model: EditViewModel

    
    init(game: Game) {
        self.game = game
        self.model = EditViewModel(game: game)
    
    
    }

    
    var body: some View {
            VStack {
                Section {
                    if !self.model.showingEdit {
                        Text(self.game.gameName ?? "Unknown Game").font(Font.custom("PressStart2p", size: 20))
                        .foregroundColor(Color.gold)
                        Text(self.game.gameDescription ?? "No Game Description")
                            .font(Font.custom("ChalkboardSE-Light", size: 15))
                            .foregroundColor(Color.gold)
                    } else {
                        EditGameView(model: EditViewModel(game: game))
                    }
                    Button(action: {
                        self.model.showingEdit.toggle()
                    }) {
                        if self.model.showingEdit == false {
                            Text("Edit Game Info")
                                .font(.caption)
                                .foregroundColor(Color.gold)
                                .underline()
                        } else {}
                    }
                }
                Section {
                    List {
                            ForEach(game.goalArray, id: \.self) { goal in
                                GameGoalListView(goal: goal)
                                    // yep yep, if you put the sheet there it can't show up if none of this views are on screen, which is the case when the goalArray is empty
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
                        }.sheet(isPresented: self.$showingAddGoal) {
                        AddGoalsView(game: self.game)
                            .environment(\.managedObjectContext, self.moc)
                            .environment(\.colorScheme, .dark)
                        }.listRowBackground(self.colorScheme == .dark ? Color.black : .none)
                    }
                .environment(\.editMode, .constant(self.model.showingEdit ? EditMode.active : EditMode.inactive)).animation(Animation.spring())
                
                // Add New Goal
                Button(action: {
                    self.showingAddGoal.toggle()
                }) {
                    HStack {
                        Image(systemName: "plus")
                        Text("Add Goal")
                    }
                    .foregroundColor(Color.gold)
                }
                
        }
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
        goal.goalOfGame = newGame
        
        return GameGoalsDetail(game: newGame).environment(\.managedObjectContext, context)
    }
}
