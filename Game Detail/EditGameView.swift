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
    @Published var showingEdit: Bool = false
    
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
    
    var body: some View {
        List {
            VStack {
                Section {
                    Text("Game Details").bold()
                }
                Divider()
                TextField("Game Name:", text: $model.newGameName)
                TextField("Game Description:", text: $model.newGameDescription)
                Divider()
                Button("Update Game") {
                    self.model.game.gameName = self.model.newGameName
                    self.model.game.gameDescription = self.model.newGameDescription
                        do {
                            try self.moc.save()
                            self.model.showingEdit = false
                            
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

