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
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    @FetchRequest(entity: Game.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Game.gameName, ascending: true)]) var games: FetchedResults<Game>
    @State private var showingAddGame = false
    @State private var showingSettings = false
    
    
    
    
    var body: some View {
        ZStack {
            NavigationView {
                if !self.games.isEmpty {
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
                                .foregroundColor(Color.gold)
                                .listRowBackground(self.colorScheme == .dark ? LinearGradient(gradient: Gradient(colors: [Color.black, Color("darkGray")]), startPoint: .top, endPoint: .bottom) : .none)
                            }
                            .onDelete(perform: self.removeGames)
                        }
                    .navigationBarItems(leading:
                        HStack {
                            Button(action: {
                                    self.showingAddGame.toggle()
                                }) {
                                    Image(systemName: "plus")
                                        .padding(10)
                                        .foregroundColor(Color.gold)
                                        
                            }
                            .sheet(isPresented: self.$showingAddGame) {
                                    AddGameView().environment(\.managedObjectContext, self.moc)
                            }
                        }, trailing:
                            Button(action: {
                                self.showingSettings.toggle()
                            }) {
                                Image(systemName: "gear")
                                    .foregroundColor(Color.gold)
                                    .padding(10)
                            }
                            .sheet(isPresented: self.$showingSettings) {
                                SettingsView().environment(\.managedObjectContext, self.moc)
                            }
                            /* EditButton()
                                .padding(10)
                                .background(LinearGradient(gradient: Gradient(colors: [Color.gold, Color.yellow, Color.gold]), startPoint: .top, endPoint: .bottom))
                                .cornerRadius(5.0)
                                .foregroundColor(Color.black) */
                    )
                    
                } else {
                    VStack {
                        Text("Let's add some games!")
                            .foregroundColor(Color.gold)
                        Button(action: {
                                self.showingAddGame.toggle()
                            }) {
                                Text("Add")
                                    
                                    .padding(10)
                                    .background(LinearGradient(gradient: Gradient(colors: [Color.gold, Color.yellow, Color.gold]), startPoint: .top, endPoint: .bottom))
                                    .cornerRadius(5.0)
                                    .foregroundColor(Color.black)
                                    
                        }
                        .sheet(isPresented: self.$showingAddGame) {
                                AddGameView().environment(\.managedObjectContext, self.moc)
                        }
                        .navigationBarItems(leading:
                            HStack {
                                Button(action: {
                                    self.showingAddGame.toggle()
                                }) {
                                    Image(systemName: "plus")
                                        .padding(10)
                                        .foregroundColor(Color.gold)
                                        
                            }
                            .sheet(isPresented: self.$showingAddGame) {
                                    AddGameView().environment(\.managedObjectContext, self.moc)
                            }
                        }, trailing:
                            Button(action: {
                                self.showingSettings.toggle()
                            }) {
                                Image(systemName: "gear")
                                    .foregroundColor(Color.gold)
                                    .padding(10)
                            }
                            .sheet(isPresented: self.$showingSettings) {
                                SettingsView().environment(\.managedObjectContext, self.moc)
                            })
                    }
                }
            }
            VStack {
                Image("Game Goals App Logo")
                .resizable()
                .frame(width: 100, height: 100)
                .offset(x: 0, y: -30)
                Spacer()
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
            .environment(\.colorScheme, .dark)
    }
}

