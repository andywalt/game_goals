//
//  ProposedFeaturesView.swift
//  Game Detail
//
//  Created by Andy Walters on 1/28/20.
//  Copyright © 2020 Andy Walt. All rights reserved.
//

import SwiftUI

struct ProposedFeaturesView: View {
    
    let featuresList = ["Adding Sorting Selections", "Cloud Sync", "User Functions"]
    
    var body: some View {
        NavigationView {
            List {
                ForEach(featuresList, id:\.self) { feature in
                    Text(feature).foregroundColor(Color.gold)
                }
            }
            .navigationBarTitle("Proposed Features", displayMode: .inline)
        }
        
        .environment(\.colorScheme, .dark)
    }
}

struct ProposedFeaturesView_Previews: PreviewProvider {
    static var previews: some View {
        ProposedFeaturesView()
    }
}
