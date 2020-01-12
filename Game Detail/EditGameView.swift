//
//  EditGameView.swift
//  Game Detail
//
//  Created by Andy Walters on 1/11/20.
//  Copyright © 2020 Andy Walt. All rights reserved.
//

import SwiftUI

struct EditGameView: View {
    
    @Environment(\.managedObjectContext) var moc
    
    @State var newGameName = ""
    @State var newGameDescription = ""

    
    var body: some View {
        List {
            VStack {
                Text("Game Details").bold()
                Divider()
                TextField("Game Name:", text: $newGameName)
                TextField("Game Description:", text: $newGameDescription)
            }
            HStack {
                Button("Update Game") {
                    init(game: Game) {
                    self.newGameName = game.gameName
                    self.newGameDescription = game.gameDescription
                        
                        do {
                            try self.moc.save()
                        } catch {
                            print(error.localizedDescription)
                        }
                    }
                }
            }
        }
    }
}

struct EditGameView_Previews: PreviewProvider {
    static var previews: some View {
        EditGameView()
    }
}

