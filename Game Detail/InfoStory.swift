//
//  InfoStory.swift
//  Game Detail
//
//  Created by Andy Walters on 1/28/20.
//  Copyright © 2020 Andy Walt. All rights reserved.
//

import SwiftUI

struct InfoStory: View {
    
    @State private var scrollText = false
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                VStack {
                    Text("A long time ago, Andy was chasing some dreams and doing all the things and then he got sick. He had to step away from his job and didn't know what life was going to look like. He started applying for jobs but couldn't find anything so in between applying, he learned to code. Game Goals is the result of wanting to make something useful for gamers everywhere! I hope you enjoy!")
                        .bold()
                        .lineSpacing(25)
                        .multilineTextAlignment(.center)
                        .foregroundColor(Color.gold)
                        .padding(.horizontal, 50)
                        .offset(y: self.scrollText ? 0 : 700)
                        .animation(Animation.linear(duration: 8))
                        .onAppear() {
                                self.scrollText.toggle()
                        }
                        
                }
            }.background(Rectangle()
                .fill(LinearGradient(gradient: Gradient(colors: [Color.black, Color("darkGray")]), startPoint: .top, endPoint: .bottom))
                .aspectRatio(geometry.size, contentMode: .fill))
        }
        .environment(\.colorScheme, .dark)
        
    }

    
}

struct InfoStory_Previews: PreviewProvider {
    static var previews: some View {
        InfoStory()
    }
}
