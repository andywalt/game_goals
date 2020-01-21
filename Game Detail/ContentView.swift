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
        // Its probably better to do this in your scenedelegate in applicationDidFinishLaunching, but doing it here should be safe.
        // Note that when you set colours like this rather than using a system color like the swiftui Color type the colour does not change for dark mode, whereas when you do use a system color you get a subtle change in colour tint to match the dark or light shade. Probably not relevant if your app is always dark but i figured i would point it out because it's rarely ever mentioned in tutorials.
        UINavigationBar.appearance().titleTextAttributes = [.font : UIFont(name: "PressStart2p", size: 20)!, .foregroundColor : UIColor(red: 248/255, green: 189/255, blue: 0/255, alpha: 1.0)]
        UINavigationBar.appearance().largeTitleTextAttributes = [.font : UIFont(name: "PressStart2p", size: 20)!]
        // Better to set the systemwide dark mode rather than metting with the UITableView and UINavigationBar appearance unless you absolutely have to
    }
    
    
    var body: some View {
        ZStack {
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
                        }//.id(UUID()) this guy is causing your game list to turn black when you tap add. I'm not sure what it's doing here, but every time the view rebuilds it gets assigned a new UUID because it calls UUID(). This doesn't seem good for an identifier, though i don't think you need it.
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
                                            // Try to avoid adjusting the dimensions of a navigationbar. UIKit's animations don't handle it well and if you really need to do it you might find its easier to construct your own navigation view container from scratch (!)
                            }
                            .sheet(isPresented: self.$showingAddGame) {
                                    AddGameView()
                                        .environment(\.managedObjectContext, self.moc)
                                        .environment(\.colorScheme, .dark)
                            }
                        }, trailing:
                            EditButton()
                                .padding(10)
                                .background(LinearGradient(gradient: Gradient(colors: [Color.gold, Color.yellow, Color.gold]), startPoint: .top, endPoint: .bottom))
                                .cornerRadius(5.0)
                                .foregroundColor(Color.black)
                    )

                }
            // Add a layer in front of the NavView to overlay the GG logo. Use a VStack with a spacer at the bottom to push the GG to the top of the screen.
            VStack {
                Image("Game Goals App Logo")
                .resizable()
                .frame(width: 100, height: 100)
                .offset(x: 0, y: -32) // -32 seems good but play around with this
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
    }
}
