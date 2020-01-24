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
    
    
    var taskDateFormat: RelativeDateTimeFormatter {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        return formatter
    }
    
    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading) {
                    if goal.goalComplete == true {
                        Text(goal.goalName ?? "No Goal Name")
                            .strikethrough()
                            .foregroundColor(Color.yellow)
                    } else {
                        Text(goal.goalName ?? "No Goal Name")
                            .foregroundColor(Color.yellow)
                    }
                    Text("Goal added: \(goal.goalCreatedDate, formatter: self.taskDateFormat)")
                        .font(.footnote)
                        .italic()
                    Text("Difficulty: \(goal.goalDifficulty ?? "")")
                        .font(.caption)
                }
                Spacer()
                Text("Complete:").font(.caption)
                    .foregroundColor(Color.yellow)
                Image(systemName: self.goal.goalComplete ? "checkmark.square.fill" : "app").onTapGesture {
                    self.goal.goalComplete.toggle()
                }
            }.foregroundColor(.yellow)
        }
        .onReceive(self.goal.objectWillChange) {
            try? self.moc.save()
        }
    }
    
}

struct GameGoalListView_Previews: PreviewProvider {
    static var previews: some View {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        let newGame = Game.init(context: context)
        newGame.gameName = "Testy Game"
        newGame.gameDescription = "Wooo play the thing"
        
        let goal = Goal(context: context)
        goal.goalName = "Try Harder"
        goal.goalComplete = false
        goal.goalCreatedDate = Date()
        goal.goalDifficulty = "Meh"
        goal.goalOfGame = newGame
        
        
        return GameGoalListView(goal: Goal()).environment(\.managedObjectContext, context)
    }
}
