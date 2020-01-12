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
    @Environment(\.editMode) var mode
    
    @State private var showingAddGoal = false
        
    @ObservedObject var game: Game
    
    var body: some View {
        VStack {
            HStack {
                EditButton()
            }
            if self.mode?.wrappedValue == .inactive {
                Text(self.game.gameName ?? "No Game Name").font(.title)
                Text(self.game.gameDescription ?? "No Game Description").font(.subheadline)
            } else {
                EditGameView(game: Game)
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
