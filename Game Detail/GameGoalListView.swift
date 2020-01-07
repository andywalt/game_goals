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
    
    @ObservedObject var goal: Goal
    
    var body: some View {
        VStack {
            HStack {
                Text(goal.goalName ?? "No Goal Name")
                Spacer()
                Text("Complete:").font(.caption)
                Image(systemName: self.goal.goalComplete ? "checkmark.square.fill" : "app").onTapGesture {
                    self.goal.goalComplete.toggle()
                    print(self.goal.goalComplete)
                }
            }
        }
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
