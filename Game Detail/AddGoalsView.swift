//
//  AddGameGoalsView.swift
//  Game Detail
//
//  Created by Andy Walters on 12/12/19.
//  Copyright © 2019 Andy Walt. All rights reserved.
//

import SwiftUI
import CoreData




struct AddGoalsView: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(entity: Game.entity(), sortDescriptors: []) var games: FetchedResults<Game>
    @Environment(\.presentationMode) var presentationMode
    
    @State private var goalName = ""
    @State private var goalDifficulty = "Easy Mode"
    
    let difficulties = ["Easy Mode", "Meh", "Help Me God"]
    
    @ObservedObject var game: Game
    
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    TextField("Add Game Goal", text: $goalName)
                    
                    HStack {
                        Spacer()
                        Text("Goal Difficulty")
                        Spacer()
                    }
                    
                    Picker("Difficulty", selection: $goalDifficulty) {
                        ForEach(difficulties, id:\.self) {
                            Text($0)
                        }
                    }.pickerStyle(SegmentedPickerStyle())
                    
                }
                VStack {
                    HStack {
                        Button(action: {
                            guard self.goalName != "" else {return}
                            let newGoal = Goal(context: self.moc)
                            newGoal.goalName = self.goalName
                            newGoal.goalComplete = false
                            newGoal.goalDifficulty = self.goalDifficulty
                            newGoal.goalCreatedDate = Date()
                            newGoal.goalOfGame = self.game
                            
                            
                            
                            do {
                                try self.moc.save()
                                self.presentationMode.wrappedValue.dismiss()
                            } catch {
                                print("Whoops! \(error.localizedDescription)")
                            }
                            
                        }) {
                            Text("Add Goal")
                        }
                            .padding(10)
                            .background(LinearGradient(gradient: Gradient(colors: [Color.gold, Color.yellow, Color.gold]), startPoint: .top, endPoint: .bottom))
                            .cornerRadius(5.0)
                            .foregroundColor(Color.black)
                            .offset(x: 0, y: -200)
                        
                    }
                    Spacer()
                    
                }
            }
        .navigationBarTitle("Add Game Goal", displayMode: .inline)
        .navigationBarItems(trailing:
            HStack {
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Cancel")
                }
                .padding(10)
                .foregroundColor(Color.white)
                .background(Color.red)
                .cornerRadius(3.0)
                .padding(10)
            })
        }
    }
}


struct AddGoalsView_Previews: PreviewProvider {
    static var previews: some View {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let newGoal = Goal(context: context)
        newGoal.goalName = "Goal 1"
        newGoal.goalComplete = false
        newGoal.goalDifficulty = "Meh"
        newGoal.goalOfGame = Game(context: context)
        newGoal.goalOfGame?.gameName = "Test Game 1"
        newGoal.goalOfGame?.gameDescription = "Maybe this will work"
        return AddGoalsView(game: Game()).environment(\.managedObjectContext, context)
            .environment(\.colorScheme, .dark)
    }
}
