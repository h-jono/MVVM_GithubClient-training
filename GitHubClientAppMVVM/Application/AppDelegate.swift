//
//  AppDelegate.swift
//  GitHubClientAppMVVM
//
//  Created by 城野 on 2021/03/23.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = .white
        window?.rootViewController = UINavigationController(rootViewController: TimeLineViewController())
        window?.makeKeyAndVisible()
        return true
    }


}

