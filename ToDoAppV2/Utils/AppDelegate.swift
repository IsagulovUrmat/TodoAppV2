//
//  AppDelegate.swift
//  ToDoAppV2
//
//  Created by Isagulov urmat on 15/1/23.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    var navController: UINavigationController?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        
        self.window = window
        
        navController = UINavigationController(rootViewController: MainViewController())
        
        navController?.navigationBar.isHidden = true
        
        window.rootViewController = navController
        
        window.makeKeyAndVisible()
        
        return true
    }



}

