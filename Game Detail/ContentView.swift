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
    
    init() {
        UINavigationBar.appearance().titleTextAttributes = [.font : UIFont(name: "PressStart2p", size: 20)!, .foregroundColor : UIColor(red: 248/255, green: 189/255, blue: 0/255, alpha: 1.0)]
        
        UINavigationBar.appearance().largeTitleTextAttributes = [.font : UIFont(name: "PressStart2p", size: 20)!]
        UINavigationBar.appearance().backgroundColor = .black
        UITableView.appearance().backgroundColor = .black
    }
    
    
    var body: some View {
        ZStack {
            Rectangle().foregroundColor(.black)
            GeometryReader { geometry in
                NavigationView {
                    List {
                        ForEach(self.games, id: \.self) { games in
                            NavigationLink(destination: GameGoalsDetail(game: games)) {
                                VStack(alignment: .leading) {
                                    Text(games.gameName ?? "Unknown Game")
                                        .font(Font.custom("PressStart2p", size: 20))
                                        .lineLimit(2)
                                        .foregroundColor(.gold)
                                    Text(games.gameDescription ?? "Unknown Game Description")
                                        .font(Font.custom("ChalkboardSE-Light", size: 15))
                                        .foregroundColor(Color.gold)
                                }
                            }
                            .listRowBackground(LinearGradient(gradient: Gradient(colors: [Color.black, Color("darkGray")]), startPoint: .top, endPoint: .bottom))
                        }
                        .onDelete(perform: self.removeGames)
                        }.id(UUID())
                    .navigationBarItems(leading:
                        HStack {
                            Button(action: {
                                    self.showingAddGame.toggle()
                                }) {
                                    Text("Add")
                                        
                                        .padding(10)
                                        .background(LinearGradient(gradient: Gradient(colors: [Color.gold, Color.yellow, Color.gold]), startPoint: .top, endPoint: .bottom))
                                        .cornerRadius(5.0)
                                        .foregroundColor(Color.black)
                                        .padding(.top, 70)
                                        
                            }
                            .sheet(isPresented: self.$showingAddGame) {
                                    AddGameView().environment(\.managedObjectContext, self.moc)
                            }
                            Image("Game Goals App Logo")
                                .resizable()
                                .frame(width: 100, height: 100)
                                .padding(.leading, (geometry.size.width / 5.0) - 0)
                                .padding(.top, 75)
                        }, trailing:
                            EditButton()
                                .padding(10)
                                .background(LinearGradient(gradient: Gradient(colors: [Color.gold, Color.yellow, Color.gold]), startPoint: .top, endPoint: .bottom))
                                .cornerRadius(5.0)
                                .foregroundColor(Color.black)
                                .padding(.top, 70)
                    )

                }
               // .navigationViewStyle(StackNavigationViewStyle())
            }
        }
        .background(Color.black)
        
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
