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
    @FetchRequest(entity: Game.entity(), sortDescriptors: []) var games: FetchedResults<Game>
    
    @ObservedObject var game: Game
    
    @State private var goalComplete : Bool = false
    
    
    var body: some View {
        VStack {
            ForEach(game.goalArray, id: \.goalName) { goal in
                HStack {
                    Text(goal.goalName ?? "No Goal Name")
                    Spacer()
                    Text("Complete:").font(.caption)
                    Image(systemName: self.goalComplete ? "checkmark.square.fill" : "app").onTapGesture {
                        self.goalComplete.toggle()
                        print(self.goalComplete)
                    }
                }
            }
        }
        
    }
}

struct GameGoalListView_Previews: PreviewProvider {
    static var previews: some View {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let newGame = Game(context: context)
        newGame.gameName = "Apex Legends"
        newGame.gameDescription = "Maybe this will work"
        return GameGoalListView(game: newGame).environment(\.managedObjectContext, context)
    }
}
