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
    
    @State private var goalComplete : Bool = false
    
    @ObservedObject var game: Game
    
    var body: some View {
        VStack {
            Text(self.game.gameName ?? "No Game Name")
            Text(self.game.gameDescription ?? "No Game Description")
            List {
                ForEach(game.goalArray, id: \.self)  { goal in
                    HStack {
                        Text(goal.goalName ?? "No Goal Name")
                        Spacer()
                        Image(systemName: self.goalComplete ? "checkmark.square.fill" : "app").onTapGesture {
                            self.goalComplete.toggle()
                            print(self.goalComplete)
                        }
                        Button(action: {
                            self.goalComplete.toggle()
                            }) {
                            if self.goalComplete == true {
                                Image(systemName: "app")
                            } else {
                                Image(systemName: "checkmark.square.fill")
                                .foregroundColor(Color.green)
                            }
                        }
                        
                    }
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
