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
    @Published var newGameGenre: String
    @Published var newGamePlatform: String
    @Published var game: Game
    @Published var showingEdit: Bool = false
    
    init(game: Game) {
        self.game = game
        self.newGameName = game.gameName ?? ""
        self.newGameGenre = game.gameGenre ?? ""
        self.newGamePlatform = game.gamePlatform ?? ""
        
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
    
    let genres = ["Shooter", "RTS", "MOBA", "RPG", "MMO", "Sports", "Action", "Adventure", "Strategy", "Puzzle", "Racing", "Fighting", ]
    
    let platforms = ["XboxOne", "PS4", "PC/Mac", "Mobile", "Nintendo Switch", ]
    
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    HStack {
                        Spacer()
                        Text("Game Details").bold()
                            .foregroundColor(Color.gold)
                        Spacer()
                    }
                    TextField("Game Name:", text: $model.newGameName)
                        .foregroundColor(Color.gold)
                    Picker("Game Genre", selection: $model.newGameGenre) {
                        ForEach(genres, id:\.self) {
                            Text($0).foregroundColor(Color.gold)
                        }.foregroundColor(Color.gold)
                    }.foregroundColor(Color.gold)
                    Picker("Game Platform", selection: $model.newGamePlatform) {
                        ForEach(platforms, id:\.self) {
                            Text($0).foregroundColor(Color.gold)
                        }.foregroundColor(Color.gold)
                    }.foregroundColor(Color.gold)
                }
            Button("Update Game") {
                self.model.game.gameName = self.model.newGameName
                self.model.game.gameGenre = self.model.newGameGenre
                self.model.game.gamePlatform = self.model.newGamePlatform
                    do {
                        try self.moc.save()
                        self.model.showingEdit = false
                        
                        
                    } catch {
                        print(error.localizedDescription)
                        
                    }
                }
                .padding(10)
                .background(LinearGradient(gradient: Gradient(colors: [Color.gold, Color.yellow, Color.gold]), startPoint: .top, endPoint: .bottom))
                .cornerRadius(5.0)
                .foregroundColor(Color.black)
            }
        }
    }
}

struct EditGameView_Previews: PreviewProvider {
    static var previews: some View {
        EditGameView(model: EditViewModel(game: Game()))
    }
}

