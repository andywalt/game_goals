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
//    @Environment(\.editMode) var mode // You can handle this as a view modifier on your List below :)
    
    @State private var showingAddGoal = false
    
    // Adding the view model to this view so that we can use it on both views
    @ObservedObject var model: EditViewModel
    @ObservedObject var game: Game
    
    // I'm moving this into the view model so that we can access it from both views
//    @State var showingEdit: Bool = false // Only needed if not using the NavigationLink approach
    
    init(game: Game) {
        // Use init() here to let us access the game and use it to create our view model. If we tried to do this just in our declarations without putting it in Init we would get an error that we can't use self before stored properties are initialised
        self.game = game
        self.model = EditViewModel(game: game)
    }
    var body: some View {
        VStack {
//            HStack {
                // I think this is for doing deletes or dragging to reorder in a list. I think this is causing problems with trying to get the edits to save.
//                EditButton()
                // Try just creating a simple bool.
                Button(action: {
                    self.model.showingEdit.toggle()
                }) {
                    Text("Edit")
                }
//            }
            if !self.model.showingEdit {
                Text(self.game.gameName ?? "No Game Name").font(.title)
                Text(self.game.gameDescription ?? "No Game Description").font(.subheadline)
                // Uncomment to experiment with switvhout out the navbar title when you change to edit mode
//                    .navigationBarTitle(Text(self.game.gameName ?? "No Game Name"), displayMode: .inline)
            } else {
                /* Almost! You are using Game (type) rather than game (instance of Game). If you change that to game you will be able to pass the specific type of Game. You would only use the Type inside of brackets like this when you're defining a function, and not when you're calling a function. When calling the function you provide the value/instance of the Type since the function already knows what Type to expect :)
                 
                 If using the View Model approach, i think the easiest way is to create the view model here and then pass along to the view right here too.
                 
                 So here we initialise an EditGameView, which requires a model parameter, so we in-line also initliase EditViewModel which takes a Game. You could write this out
                 
                 let model: EditViewModel = EditViewModel(game: self.game)
                 EditGameView(model: model)
                 
                 If you really wanted to.
                 */
                EditGameView(model: model) // View Model
//                EditGameView(game: game) // @State
                
                
//                    .onAppear {
//                        // I think this is where the onAppear goes but I'd imagine that I have to create a whole method like self.updatedGameInfo.gameName = self.game.gameName & a  self.updatedGameInfo = self.game.gameDescription
//                    }
//                    .onDisappear {
//                        // self.game.gameName = self.updatedGameInfo.gameName
//                    }
                
                /* onAppear and onDisappear would need to be used within EditGameView itself. I'm actually not sure what they would do here. They cause the view in which they exist to perform some action when the view that they are modifying appears or disappears.
                 
                 Put differently,imagine you have something like this where you want an alert to pop up when the label "Goose" scrolls onto the screen
                 
                 struct DuckDuckGoose: View {
                    var body: some View {
                        ScrollView {
                 
                            Text("Duck")
                            Text("Duck")
                            Text("Duck")
                            Text("Duck")
                            Text("Duck")
                            Text("Duck")
                            Text("Duck")
                            Text("Duck")
                            Text("Goose!")
                                .onAppear {
                                    showAlertFunction()
                                }
                 
                        }.font(.largeTitle)
                 
                    }
                 }
                 
                 
                 In this case, when Goose shows on screen in the view, the .onAppear modifier on the Text() item will trigger its closure. Likewise .onDisappear would trigger a closure when scrolling off the screen.

                */
            }
            List {
                ForEach(game.goalArray, id: \.self) { goal in
                    GameGoalListView(goal: goal)
                }
                .onDelete { index in
                    let deleteGoal = self.game.goalArray[index.first!]
                    self.moc.delete(deleteGoal)
                    
                    do {
                        try self.moc.save()
                    } catch {
                        print(error)
                    }
                }
            }
                // You can control the editMode for the list here based on your showingEdit bool
                .environment(\.editMode, .constant(self.model.showingEdit ? EditMode.active : EditMode.inactive))
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
