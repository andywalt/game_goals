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
                if goal.goalComplete == true {
                    Text(goal.goalName ?? "No Goal Name")
                        .strikethrough()
                        .foregroundColor(Color.yellow)
                } else {
                    Text(goal.goalName ?? "No Goal Name")
                        .foregroundColor(Color.yellow)
                }
                Spacer()
                Text("Complete:").font(.caption)
                    .foregroundColor(Color.yellow)
                Image(systemName: self.goal.goalComplete ? "checkmark.square.fill" : "app").onTapGesture {
                    self.goal.goalComplete.toggle()
                }.foregroundColor(.yellow)
            }
            .background(Color.black)
        }
            .background(Color.black)
        .onReceive(self.goal.objectWillChange) {
            try? self.moc.save()
        }
    }
}

struct GameGoalListView_Previews: PreviewProvider {
    static var previews: some View {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        let goal = Goal(context: context)
        goal.goalName = "Try Harder"
        goal.goalComplete = false
        goal.goalOfGame?.gameName = "Apex Legends"
        
        return GameGoalListView(goal: Goal()).environment(\.managedObjectContext, context)
    }
}
