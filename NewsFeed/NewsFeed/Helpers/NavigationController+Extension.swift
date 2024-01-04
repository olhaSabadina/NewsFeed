//
//  NavigationController+Extension.swift
//  NewsFeed
//
//  Created by Olga Sabadina on 12.12.2023.
//

import UIKit

extension UIViewController {
    
    func setUpNavBarColor() {
        let appearance = UINavigationBarAppearance()
        appearance.titleTextAttributes = [.foregroundColor : UIColor.white]
        navigationItem.standardAppearance = appearance
        UIBarButtonItem.appearance().tintColor = .white
    }
}
