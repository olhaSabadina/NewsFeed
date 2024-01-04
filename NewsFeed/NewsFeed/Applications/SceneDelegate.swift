//
//  SceneDelegate.swift
//  NewsFeed
//
//  Created by Olga Sabadina on 12.12.2023.
//

import UIKit
import GoogleMobileAds

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    let networkMonitor = NetworkMonitor.shared

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
 
        let startVC = TabBarController(networkMonitor: networkMonitor)
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = startVC
        window?.makeKeyAndVisible()
        networkMonitor.startMonitor()
        
        GADMobileAds.sharedInstance().start(completionHandler: nil)
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        networkMonitor.stopMonitoring()
    }
}

