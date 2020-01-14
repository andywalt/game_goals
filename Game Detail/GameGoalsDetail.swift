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
    
    @State private var showingAddGoal = false
        
    @ObservedObject var game: Game
    
    @State var showingEdit: Bool = false
    
    var body: some View {
        VStack {
            Button(action: {
                self.showingEdit.toggle()
            }) {
                Text("Edit Game")
            }
            
            if !self.showingEdit {
                Text(self.game.gameName ?? "No Game Name").font(.title)
                Text(self.game.gameDescription ?? "No Game Description").font(.subheadline)
            } else {
                EditGameView(model: EditViewModel(game: game))
            }
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
            .environment(\.editMode, .constant(self.showingEdit ? EditMode.active : EditMode.inactive))
            
            // Add New Goal
            Button(action: {
                self.showingAddGoal.toggle()
            }) {
                HStack {
                    Image(systemName: "plus")
                    Text("Add Goal")
                }
            }
            .sheet(isPresented: $showingAddGoal) {
                AddGameGoalsView(game: self.game).environment(\.managedObjectContext, self.moc)
            }
        }
    }
}



struct GameGoalsDetail_Previews: PreviewProvider {
    static var previews: some View {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let newGame = Game(context: context)
        newGame.gameName = "Apex Legends"
        newGame.gameDescription = "Maybe this will work"
        return GameGoalsDetail(game: newGame).environment(\.managedObjectContext, context)
    }
}
