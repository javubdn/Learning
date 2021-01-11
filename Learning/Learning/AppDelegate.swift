//
//  AppDelegate.swift
//  Learning
//
//  Created by Javi Castillo Risco on 10/01/2021.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        initAplication()
        return true
    }

    private func initAplication() {
        guard let window = window else {
            return
        }
        let tabBar = UITabBarController()

        let initGameViewController = InitGameViewController()
        let gameNavigationController = UINavigationController(rootViewController: initGameViewController)
        tabBar.viewControllers = [gameNavigationController]
        tabBar.tabBar.barTintColor = .blue
        window.rootViewController = tabBar
    }

}

