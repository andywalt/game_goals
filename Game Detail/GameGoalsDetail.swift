//
//  GameGoalsDetail.swift
//  Game Detail
//
//  Created by Andy Walters on 12/12/19.
//  Copyright © 2019 Andy Walt. All rights reserved.
//

import SwiftUI


struct GameGoalsDetail: View {
    @Environment(\.managedObjectContext) var moc
    
    /*
     // You just want the goals associated with this one Game, and the Game holds a reference to those goals in the form of its gameGoals array. If you create an array of goals from a fetchrequest, you would need to add as predicate to filter for goals where their Game matches this Game. Additionally, the resulting array may be sorted differently to your gameGoals array which becomes perilous if deleting is going to happen by index reference.
     
     Conveniently, we can just use the goalArray property directly without needing to create another source of truth. It looks like you already sort that array in your model. Right now when the view appears the sorting is correct, though the items don't auto-resort as you click the checkmark buttons. You could probably use .onRecieve and objectWillChange for that, similar to how you can use it to save the managed object context when its tapped :) 
          
     Also, I was making this exact same error in my own app and I only discovered it thanks to debugging this example here!
     
     
    // Added this FetchRequest so Goals can be found in deleteGoal function. Still not sure how to access the index of the GameGoalListView goal or the inherited game goal from the view in the managedObjectContext.
    @FetchRequest(entity: Goal.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Goal.goalComplete, ascending: true)]) var goals: FetchedResults<Goal>
 
 */
    
    @State private var showingAddGoal = false
        
    @ObservedObject var game: Game
    
    var body: some View {
        VStack {
            Text(self.game.gameName ?? "No Game Name").font(.title)
            Text(self.game.gameDescription ?? "No Game Description").font(.subheadline)
            List {
                ForEach(game.goalArray, id: \.self) { goal in
                    GameGoalListView(goal: goal)
                    
                }
                .onDelete { index in
                    
                    /*
                     Just change the data source for the delete from self.goals to self.game.goalArray so that rendering and deletion happen from the same array

                     With this change i now see that goals always delete with the first delete command rather than appearing to not respond the first time or two (i.e. the command isn't deleting a DIFFERENT item now), and i cannot observe any other goals disappearing when i check other games.
                     */
                    let goalToDelete = self.game.goalArray[index.first!]
                    self.moc.delete(goalToDelete)
                    
                    do {
                        try self.moc.save()
                    } catch {
                        print(error)
                    }
                }
            }
            Button(action: {
                self.showingAddGoal.toggle()
            }) {
                HStack {
                    Image(systemName: "plus")
                    Text("Add Goal")
                }
            }
            .sheet(isPresented: $showingAddGoal) {
                AddGameGoalsView(game: self.game).environment(\.managedObjectContext, self.moc)
            }
        }
    }
    /*
     You're getting the index from your Game.goalsArray and then using that index in your fetched array of all Goals from all Games. Discussion in comment at the FetchRequest
     
     Basically the approach that uses a fetchrequest as seen in a lot of tutorials is valid if you're presenting a list of every Goal, but doesn't work if the fetch request is not the same source of truth that the view is using in the ForEach. Everything in SwiftUI seems to be about minimising the number of sources of truth currently in play.
     
     Style-wise: You can do this as a function like this, or you can use a trailing closure on .onDelete. The do-try-catch block is a bit of an eyesore up there in the body code but it feels "swiftier" to me. I think this is probably just style preference though; I don't think this is causing your problem.
     */
    /*
     
     // if not using the trailing closure, this is the function you used but changed to reference the correct array
     
     
     func deleteGoal(at offsets: IndexSet) {
     for index in offsets {
     let goal = self.game.goalArray[index]
     self.moc.delete(goal)
     }
     do {
     try moc.save()
     } catch {
     print(error)
     }
     }
     
     */
    
//    // trying to delete the goal selected but it's deleting random goals and even goals in other games.
//    func deleteGoal(at offsets: IndexSet) {
//        for index in offsets {
//            let goal = self.goals[index]
//            self.moc.delete(goal)
//        }
//        do {
//            try moc.save()
//        } catch {
//            print(error)
//        }
//    }
    

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
