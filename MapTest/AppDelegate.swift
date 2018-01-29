//
//  AppDelegate.swift
//  MapTest
//
//  Created by Maciej Koziel on 26/01/2018.
//  Copyright © 2018 Maciej Koziel. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        window = UIWindow(frame: UIScreen.main.bounds)
        if let window = window {
            let viewController = ViewController()
            window.rootViewController = viewController
            window.makeKeyAndVisible()
        }
        
        return true
    }
}
