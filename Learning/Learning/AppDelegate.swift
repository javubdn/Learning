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
        let wordsViewController = WordsViewController()
        let gameNavigationController = UINavigationController(rootViewController: initGameViewController)
        let wordsNavigationController = UINavigationController(rootViewController: wordsViewController)
        tabBar.viewControllers = [gameNavigationController, wordsNavigationController]
        gameNavigationController.title = "Juego"
        gameNavigationController.tabBarItem.image = UIImage(named: "gameIcon")
        wordsNavigationController.title = "Palabras"
        wordsNavigationController.tabBarItem.image = UIImage(named: "wordsIcon")
        tabBar.tabBar.barTintColor = .blue
        window.rootViewController = tabBar
    }

}

