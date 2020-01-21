//
//  AddGameView.swift
//  Game Detail
//
//  Created by Andy Walters on 12/11/19.
//  Copyright © 2019 Andy Walt. All rights reserved.
//

import SwiftUI
import CoreData


struct AddGameView: View {
    
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(entity: Game.entity(), sortDescriptors: []) var games: FetchedResults<Game>
    @Environment(\.presentationMode) var presentationMode
    
    @State private var gameName = ""
    @State private var gameDescription = ""
    @State private var showingAlert = false
    
    var body: some View {
        NavigationView {
            Form {
                Text("Let's get to tracking!")
                Section {
                    TextField("Game Name", text: $gameName)
                    TextField("Game Description", text: $gameDescription)
                }
                HStack {
                    Button("Add Game") {
                        let newGame = Game(context: self.moc)
                        newGame.gameName = self.gameName
                        newGame.gameDescription = self.gameDescription
                        
                        do {
                            try self.moc.save()
                            self.presentationMode.wrappedValue.dismiss()
                        } catch {
                            print("Whoops! \(error.localizedDescription)")
                        }
                        
                    }
                }
            }
            .navigationBarTitle("Add Game", displayMode: .inline)
            .navigationBarItems(trailing:
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                    print()
                }) {
                    Text("Cancel")
                }
                .padding(10)
                .foregroundColor(Color.white)
                .background(Color.red)
                .cornerRadius(/*@START_MENU_TOKEN@*/3.0/*@END_MENU_TOKEN@*/)
            )
        }
    }
}

struct AddGameView_Previews: PreviewProvider {
    static var previews: some View {
        AddGameView()
    }
}
