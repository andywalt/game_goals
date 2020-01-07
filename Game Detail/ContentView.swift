//
//  ContentView.swift
//  Game Detail
//
//  Created by Andy Walters on 12/11/19.
//  Copyright © 2019 Andy Walt. All rights reserved.
//

import SwiftUI
import CoreData


struct ContentView: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(entity: Game.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Game.gameName, ascending: true)]) var games: FetchedResults<Game>
    @State private var showingAddGame = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(games, id: \.self) { games in
                    NavigationLink(destination: GameGoalsDetail(game: games)) {
                        VStack(alignment: .leading) {
                            Text(games.gameName ?? "Unknown Game")
                                .font(.title)
                            Text(games.gameDescription ?? "Unknown Game Description")
                                .font(.subheadline)
                        }
                    }
                }
                .onDelete(perform: removeGames)
            }
            .navigationBarTitle("Game Goals")
            .navigationBarItems(leading: EditButton(), trailing: Button("Add") {
                self.showingAddGame.toggle()
            })
                .sheet(isPresented: $showingAddGame) {
                    AddGameView().environment(\.managedObjectContext, self.moc)
            }
        }
    }
    
    func removeGames(at offsets: IndexSet) {
        for index in offsets {
            let game = games[index]
            moc.delete(game)
        }
        try? moc.save()
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        return ContentView().environment(\.managedObjectContext, context)
    }
}


/*
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

*/
