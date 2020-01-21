//
//  NavigationBarView.swift
//  Game Detail
//
//  Created by Andy Walters on 1/20/20.
//  Copyright © 2020 Andy Walt. All rights reserved.
//

import Foundation
import SwiftUI


struct NavigationConfigurator: UIViewControllerRepresentable {
    var configure: (UINavigationController) -> Void = { _ in }

    func makeUIViewController(context: UIViewControllerRepresentableContext<NavigationConfigurator>) -> UIViewController {
        UIViewController()
    }
    func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<NavigationConfigurator>) {
        if let nc = uiViewController.navigationController {
            self.configure(nc)
        }
    }

}
