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
                    Text(goal.goalName ?? "No Goal Name").strikethrough()
                } else {
                    Text(goal.goalName ?? "No Goal Name")
                }
                Spacer()
                Text("Complete:").font(.caption)
                Image(systemName: self.goal.goalComplete ? "checkmark.square.fill" : "app").onTapGesture {
                    self.goal.goalComplete.toggle()
                }.foregroundColor(.yellow)
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
        let newGoal = Goal(context: context)
        newGoal.goalName = "Try and Try Again"
        newGoal.goalComplete = false
        return GameGoalListView(goal: Goal()).environment(\.managedObjectContext, context)
    }
}
