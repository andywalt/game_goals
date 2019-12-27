//
//  GameGoalsDetail.swift
//  Game Detail
//
//  Created by Andy Walters on 12/12/19.
//  Copyright © 2019 Andy Walt. All rights reserved.
//

import SwiftUI
import CoreData

struct GameGoalsDetail: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(entity: Game.entity(), sortDescriptors: []) var games: FetchedResults<Game>
    
    @State private var showingAddGoal = false
    
    @State private var goalComplete = false
    
    let game: Game
    
    var body: some View {
        VStack {
            Text(self.game.wrappedGameName)
            Text(self.game.wrappedGameDescription)
            ForEach(game.goalArray, id: \.self)  { goal in
                Text(goal.wrappedGoalName)
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


    
    /*
    static var previews: some View {
        let game = Game(context: moc)
        game.wrappedGameName = "Test Game"
        game.wrappedGameDescription = "Test Game Description"
        game.goalArray = ["Goal 1", "Goal 2"]
        
        GameGoalsDetail(game: game)
    }
}
 */
