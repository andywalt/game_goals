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
    
    // Added this FetchRequest so Goals can be found in deleteGoal function. Still not sure how to access the index of the GameGoalListView goal or the inherited game goal from the view in the managedObjectContext.
    @FetchRequest(entity: Goal.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Goal.goalComplete, ascending: true)]) var goals: FetchedResults<Goal>
    
    @State private var showingAddGoal = false
        
    @ObservedObject var game: Game
    
    var body: some View {
        VStack {
            Text(self.game.gameName ?? "No Game Name").font(.title)
            Text(self.game.gameDescription ?? "No Game Description").font(.subheadline)
            List {
                ForEach(game.goalArray, id: \.self) { goal in
                    GameGoalListView(goal: goal)
                }
                    .onDelete(perform: deleteGoal)
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
    // trying to delete the goal selected but it's deleting random goals and even goals in other games.
    func deleteGoal(at offsets: IndexSet) {
        for index in offsets {
            let goal = self.goals[index]
            self.moc.delete(goal)
        }
        do {
            try moc.save()
        } catch {
            print(error)
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
