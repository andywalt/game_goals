//
//  GameGoalListView.swift
//  Game Detail
//
//  Created by Andy Walters on 1/2/20.
//  Copyright © 2020 Andy Walt. All rights reserved.
//

import SwiftUI
import CoreData


struct GameGoalListView: View {
    
    @Environment(\.managedObjectContext) var moc
    // We are going to pass in the specific Goal we are working with below, so we aren't fetching any data from CoreData here
    //    @FetchRequest(entity: Game.entity(), sortDescriptors: []) var games: FetchedResults<Game>
    
    // We want to work with Goals on this view, so we don't care about Games.
    //    @ObservedObject var game: Game
    @ObservedObject var goal: Goal
    
    
    // Using @State creates a new source of truth, which we don't want to do. In this case you want to use the Bool already defined on the Goal object.
    //    @State private var goalComplete : Bool = false
    
    var body: some View {
        VStack {
            
            // Remove the ForEach here. Since you're passing in the Goal you don't need to iterate through all the goals in the array. The ForEach on GameGoalsDetail will create a new GameGoalListView for each Goal in the goalArray. Because of this, your GameGoalListView only needs to know about one goal :)
            //          ForEach(game.goalArray, id: \.goalName) { goal in
            HStack {
                Text(goal.goalName ?? "No Goal Name")
                Spacer()
                Text("Complete:").font(.caption)
                // Use the goalComplete already defined on the goal object rather than makinga new boolean on the view.
                Image(systemName: self.goal.goalComplete ? "checkmark.square.fill" : "app").onTapGesture {
                    
                    self.goal.goalComplete.toggle()
                    print(self.goal.goalComplete)
                }
                
            }
            
        }
            // Use the objectWillChange publisher in your NSManagedObject to tell you that one of its published properties (any with @NSManaged) changed, and use that trigger to tell the managed object context to perform a save operation
            .onReceive(self.goal.objectWillChange) {
                try? self.moc.save()
        }
    }
}

struct GameGoalListView_Previews: PreviewProvider {
    static var previews: some View {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let newGame = Game(context: context)
        newGame.gameName = "Apex Legends"
        newGame.gameDescription = "Maybe this will work"
        return GameGoalListView(goal: Goal()).environment(\.managedObjectContext, context)
    }
}
