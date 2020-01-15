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
        GeometryReader { geometry in
            NavigationView {
                List {
                    ForEach(self.games, id: \.self) { games in
                        NavigationLink(destination: GameGoalsDetail(game: games)) {
                            VStack(alignment: .leading) {
                                Text(games.gameName ?? "Unknown Game")
                                    .font(Font.custom("PressStart2p", size: 20))
                                    .lineLimit(2)
                                Text(games.gameDescription ?? "Unknown Game Description")
                                    .font(Font.custom("ChalkboardSE-Light", size: 15))
                            }
                        }
                    }
                    .onDelete(perform: self.removeGames)
                    }
                    
                .navigationBarItems(leading:
                    HStack {
                        Button(action: {
                                self.showingAddGame.toggle()
                            }) {
                                Text("Add Game")
                                    .padding(.top, 50)
                                    .foregroundColor(Color.yellow)
                        }
                        Image("Game Goals App Logo")
                        .resizable()
                        .frame(width: 100, height: 100)
                        .padding(.leading, (geometry.size.width / 2.0) + -160)
                        .padding(.bottom, -50)
                    }, trailing:
                        EditButton()
                            .padding(.top, 50)
                            .foregroundColor(Color.yellow)
                            )
                    .sheet(isPresented: self.$showingAddGame) {
                        AddGameView().environment(\.managedObjectContext, self.moc)
                }
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
        let newGame = Game(context: context)
        newGame.gameName = "Apex Legends"
        newGame.gameDescription = "Maybe this will work"
        return ContentView().environment(\.managedObjectContext, context)
    }
}
