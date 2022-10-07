//
//  SceneDelegate.swift
//  Matches
//
//  Created by Kirill Drozdov on 26.12.2021.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window?.windowScene = windowScene
        window?.makeKeyAndVisible()
        let controller = ViewController()
        let navController = UINavigationController(rootViewController: controller)
        navController.toolbar.backgroundColor = .white
        navController.navigationBar.backgroundColor = .white
        window?.rootViewController = navController
    }

    func sceneDidDisconnect(_ scene: UIScene) {
   
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
    
    }

    func sceneWillResignActive(_ scene: UIScene) {
  
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
      
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }
}

