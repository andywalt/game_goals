//
//  GameGoalsDetail.swift
//  Game Detail
//
//  Created by Andy Walters on 12/12/19.
//  Copyright © 2019 Andy Walt. All rights reserved.
//

import SwiftUI
//import CoreData

struct GameGoalsDetail: View {
    @Environment(\.managedObjectContext) var moc
    
    // The Game is passed into the view below, so it's not neccesary to reference a fetch request on this view :) This is effectively just a fancy array of games, but we only care about the game given to us by the previous view
    //    @FetchRequest(entity: Game.entity(), sortDescriptors: []) var games: FetchedResults<Game>
    //
    @State private var showingAddGoal = false
    
    // I don't think anything is using this property, and it would be creating a new, disconencted source of truth. Does it need to be here?
    //    @State private var goalComplete : Bool = false
    
    @ObservedObject var game: Game
    
    var body: some View {
        VStack {
            Text(self.game.gameName ?? "No Game Name").font(.title)
            Text(self.game.gameDescription ?? "No Game Description").font(.subheadline)
            List {
                ForEach(game.goalArray, id: \.self)  { goal in
                    // You want to show a cell that knows about a Goal. It doesn't need to know about the game, its just showing one Goal. So you'd want to pass in the goal directly, which is why you have the "goal in" in the closure :)
                    //                    GameGoalListView(game: self.game).environment(\.managedObjectContext, self.moc)
                    
                    // You don't need to pass in the managed object context if you're staying within the view hierarchy (in this case staying inside the NavigationView). This is because sub-views inherit the environment of their parent view. You do need to pass it to .sheet because sheets are outside the view hierarchy and so do not inherit the environment!
                    //                    GameGoalListView(game: game)
                    GameGoalListView(goal: goal)
                    
                }
            }
            Button("Add Game Goal") {
                self.showingAddGoal.toggle()
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
