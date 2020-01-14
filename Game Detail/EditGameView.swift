//
//  EditGameView.swift
//  Game Detail
//
//  Created by Andy Walters on 1/11/20.
//  Copyright © 2020 Andy Walt. All rights reserved.
//

import SwiftUI
import Combine

class EditViewModel: ObservableObject {
    
    @Published var newGameName: String
    @Published var newGameDescription: String
    @Published var game: Game
    
    init(game: Game) {
        self.game = game
        self.newGameName = game.gameName ?? ""
        self.newGameDescription = game.gameDescription ?? ""
        
        self.$game
            .sink { _ in
                self.objectWillChange.send()
        }
        .store(in: &cancellables)
    }
    private var cancellables = Set<AnyCancellable>()
}

struct EditGameView: View {
    
    @Environment(\.managedObjectContext) var moc
    
    @ObservedObject var model: EditViewModel
    
    @State var showingEdit: EditMode = .inactive
    
    var body: some View {
        List {
            VStack {
                Text("Game Details").bold()
                Divider()
                TextField("Game Name:", text: $model.newGameName)
                TextField("Game Description:", text: $model.newGameDescription)
                Divider()
                Button("Update Game") {
                    self.model.game.gameName = self.model.newGameName
                    self.model.game.gameDescription = self.model.newGameDescription
                        do {
                            try self.moc.save()
                            self.showingEdit = .active
                            //When this button gets clicked it needs to tell the showingEdit to toggle to false again.
                            // tried self.showingEdit = false
                            // tried self.showingEdit.toggle()
                            
                            // would I need to make @State on GameGoalsDetail a @Binding because it's a two way connection?
                            
                            // tried Environment(\.editMode) = .inactive
                            
                            //aghhhhhh angry noises
                            
                        } catch {
                            print(error.localizedDescription)
                            
                        }
                    }
                }
          }
    }
}

struct EditGameView_Previews: PreviewProvider {
    static var previews: some View {
        EditGameView(model: EditViewModel(game: Game()))
    }
}

