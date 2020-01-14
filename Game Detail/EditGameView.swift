//
//  EditGameView.swift
//  Game Detail
//
//  Created by Andy Walters on 1/11/20.
//  Copyright © 2020 Andy Walt. All rights reserved.
//

import SwiftUI
import Combine

/* This is a basic view model. It contains the state and logic for the view so that the view can be dumb. It also means we can get around annoying initialiser restrictions because of state */
class EditViewModel: ObservableObject {
    
    @Published var newGameName: String
    @Published var newGameDescription: String
    @Published var game: Game
    // moved this Bool into the view model
    @Published var showingEdit: Bool = false
    
    init(game: Game) {
        self.game = game
        self.newGameDescription = game.gameDescription ?? ""
        self.newGameName = game.gameName ?? ""
        
        // This is using combine to subscribe to "objectWillChange" subjects from the Game and forward them to the view as part of the ObservableObject magic. Dont get too worried about this.
        // $game is a publisher that publishes type Passthroughsubject<Void, Never>, which is just a blank token that tells us that the observed object changed.
        self.$game
            // sink just means "use the values received through this subscription in this closure"
            .sink { _ in
                // we just use "_ in" rather than like "value in" or whatever because we dont care about the actual value here (and indeed, its just a blank item) but we DO care about it allowing us to trigger an action. In this case, we use it to call the send() method on EditViewModel's own objectWillChange property (its a property that is automatically inherited via the ObservableObject protocol, but you can declare it yourself at the top of the class scope with "let objectWillChange = Passthroughsubject<Void, Never>()" You dont need to though, and don't get confused by this. This is not super important right now! The important thing is to just understand that this objectWillChange publisher is the secret sauce that makes the view update when the @ObservedObject changes. The view automatically subscribes to this publisher and refreshes the view every time it receives objectWillChange from this object.
                //  So to recap, the view model receives the "Hey i changed!" message from GAME, and then the view model sends a new "Hey i changed!" message to the view, which responds by rebuilding its body.
                self.objectWillChange.send()
        }
            // I'm still trying to underand what store does (the combine book is so thick omg), but i do know that it doesn't work without this so.....  (It's basically some way to store the publisher and its values in a way that iOS can clean up the memory for cleanly.. or something, idk!
        .store(in: &cancellables)
    }
    // Also confusing> This has something to do with subcribers (Cancellables). Necessary for store.
    private var cancellables = Set<AnyCancellable>()
}

struct EditGameView: View {
    
    @Environment(\.managedObjectContext) var moc
    
    /*
   You need this if you don't use a view model (see below)
     */
//    @ObservedObject var game: Game // @State
    
    /* .onAppear has some potential side effects (UI 'glitches' as things update as the view loads), but you can avoid this by using a view model. This is more complex than i originally intended but i was wrong when i thought you could use init() in the struct here. I was conufsed. */
    @ObservedObject var model: EditViewModel // View Model
    
//    @State var newGameName: String = "" // @State
//    @State var newGameDescription: String // @State

    /*
     I originally thought you could use init() here but i forgot that you can't initialise a @State variable.
     If you dont like the view model and want to see the .onAppear method, uncomment the @State  and then comment out all the ViewModel stuff
     */
    
    var body: some View {
        List {
            VStack { // This VStack is crushing this into one cell. Are you perhaps looking for Section?
//            Section {
                Text("Game Details").bold() // You might like to put this in the navigation bar title (see below)
                Divider()
                TextField("Game Name:", text: $model.newGameName) // View Model
                TextField("Game Description:", text: $model.newGameDescription) // View Model
//                TextField("Game Name:", text: $newGameName) // @State
//                TextField("Game Description:", text: $newGameDescription).onAppear { // @State
//                    self.newGameName = self.game.gameName ?? "" // @State
//                    self.newGameDescription = self.game.gameDescription ?? "" // @State
//            } // @State
            }
//            HStack { // Not needed unless you want to stack another view horizontally within the cell)
                Button("Update Game") {
                    
                    /*
                     • Presumably this button's task is to take the new values entered into the view, and use themn to replace the old values in the Game object
                     • Flip these expressions above around so that you're assigning from the view to the game object:
                     */

                /*  existing object   <--      new values  */
                    self.model.game.gameName = self.model.newGameName // View Model
                    self.model.game.gameDescription = self.model.newGameDescription // View Model
//                    self.game.gameName = self.newGameName // @State
//                    self.game.gameDescription = self.newGameDescription // @State

                        /* Even though the Game has new values, its only stored in RAM until we tell CoreData to change the value in the persistent store by saving */
                        do {
                            try self.moc.save()
                        } catch {
                            print(error.localizedDescription)
                        }
                    // Tell the view model to dismiss the Edit screen
                    self.model.showingEdit = false
//                    }
//                }
            }
        }
//            //Navigation bar modifiers are weird. You need to put them INSIDE the navigation view. IT doesn't actually matter where inside this view you put it, since this view is wholly within the navigation view
//            .navigationBarTitle(Text("Game Details"), displayMode: .inline)
//        You can use a different title modifier within the details view (the part that gets switched out for this edit view) and the title would change as the edit mode changed.
//        Uncomment if you'd like to experiment with this
    }
}

struct EditGameView_Previews: PreviewProvider {
    static var previews: some View {
        EditGameView(model: EditViewModel(game: Game()))
    }
}

