//
//  SettingsView.swift
//  Game Detail
//
//  Created by Andy Walters on 1/28/20.
//  Copyright © 2020 Andy Walt. All rights reserved.
//

import SwiftUI

struct SettingsView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 10) {
                Section(header: Text("Info")) {
                    NavigationLink(destination: InfoStory()) {
                        HStack {
                            Image(systemName: "book.circle.fill")
                            Text("Story of Game Goals")
                            Spacer()
                            Image(systemName: "chevron.right")
                        }
                        .foregroundColor(Color.gold)
                        .padding(.all, 10)
                        .background(LinearGradient(gradient: Gradient(colors: [Color.black, Color("darkGray")]), startPoint: .top, endPoint: .bottom))
                        .cornerRadius(10)
                        .padding(.trailing, 100)
                        
                    }
                }
                .foregroundColor(Color.gray)
                .padding(.leading, 30)
                Section(header: Text("Send Feedback")) {
                    Button(action: {
                        let email = "andywalters42@gmail.com"
                        if let url = URL(string: "mailto:\(email)") {
                            if #available(iOS 10.0, *) {
                                UIApplication.shared.open(url)
                            } else {
                                UIApplication.shared.openURL(url)
                            }
                        }
                    }) {
                        Image(systemName: "envelope.circle.fill")
                        Text("Email")
                        Spacer()
                        Image(systemName: "chevron.right")
                    }
                    .foregroundColor(Color.gold)
                    .padding(.all, 10)
                    .background(LinearGradient(gradient: Gradient(colors: [Color.black, Color("darkGray")]), startPoint: .top, endPoint: .bottom))
                    .cornerRadius(10)
                    .padding(.trailing, 100)
                    Button(action: {
                        UIApplication.shared.open(URL(string: "https://twitter.com/andywalt")!)
                    }) {
                        Image("Twitter_Social_Icon_Circle_White")
                            .resizable()
                            .frame(width: 15, height: 15)
                        Text("Twitter")
                        Spacer()
                        Image(systemName: "chevron.right")
                    }
                    .foregroundColor(Color.gold)
                    .padding(.all, 10)
                    .background(LinearGradient(gradient: Gradient(colors: [Color.black, Color("darkGray")]), startPoint: .top, endPoint: .bottom))
                    .cornerRadius(10)
                    .padding(.trailing, 100)
                }
                .foregroundColor(Color.gray)
                .padding(.leading, 30)
                Section(header: Text("Development")) {
                    NavigationLink(destination: ProposedFeaturesView()) {
                        HStack {
                            Image(systemName: "bolt.fill")
                            Text("Proposed Features")
                            Spacer()
                            Image(systemName: "chevron.right")
                        }
                        .foregroundColor(Color.gold)
                        .padding(.all, 10)
                        .background(LinearGradient(gradient: Gradient(colors: [Color.black, Color("darkGray")]), startPoint: .top, endPoint: .bottom))
                        .cornerRadius(10)
                        .padding(.trailing, 100)
                    }
                        
                        Button(action: {
                            UIApplication.shared.open(URL(string: "https://github.com/andywalt/game_detail")!)
                        }) {
                            Image("GitHub-Mark-120px-plus")
                                .resizable()
                                .frame(width: 15, height: 15)
                            Text("Github")
                            Spacer()
                            Image(systemName: "chevron.right")
                        }
                        .foregroundColor(Color.gold)
                        .padding(.all, 10)
                        .background(LinearGradient(gradient: Gradient(colors: [Color.black, Color("darkGray")]), startPoint: .top, endPoint: .bottom))
                        .cornerRadius(10)
                        .padding(.trailing, 100)
                }
                .foregroundColor(Color.gray)
                .padding(.leading, 30)
                }.offset(x: 0, y: -10)
            .navigationBarTitle("Settings", displayMode: .inline)
            .navigationBarItems(trailing:
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()

                }) {
                    Image(systemName: "hand.thumbsup.fill")
                }
                .padding(10)
                .foregroundColor(Color.gold)
                .padding(.bottom, 10)
            )
        }.environment(\.colorScheme, .dark)
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
