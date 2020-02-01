//
//  ProposedFeaturesView.swift
//  Game Detail
//
//  Created by Andy Walters on 1/28/20.
//  Copyright © 2020 Andy Walt. All rights reserved.
//

import SwiftUI

struct ProposedFeaturesView: View {
    
    let featuresData: [Feature] =
        [Feature(image: "coin", feature: "Adding Sorting Selections"),
        Feature(image: "coin", feature: "Cloud Sync"),
        Feature(image: "coin", feature: "User Profiles"),
        Feature(image: "coin", feature: "AutoComplete Games & Goals"),
        Feature(image: "coin", feature: "More to Come!")]
    
    var body: some View {
        NavigationView {
            List(featuresData) { feature in
                HStack {
                    Image(feature.image)
                        .resizable()
                        .frame(width: 15, height: 15)
                        .padding(.leading, 5)
                    Text(feature.feature).foregroundColor(Color.gold)
                        .padding(5)
                }
            }
            .navigationBarTitle("Proposed Features", displayMode: .inline)
        }
        
        .environment(\.colorScheme, .dark)
    }
}

struct Feature: Identifiable {
    var id = UUID()
    var image: String
    var feature: String
}

struct ProposedFeaturesView_Previews: PreviewProvider {
    static var previews: some View {
        ProposedFeaturesView()
    }
}
