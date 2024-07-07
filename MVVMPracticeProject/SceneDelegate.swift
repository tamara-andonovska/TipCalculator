//
//  SceneDelegate.swift
//  MVVMPracticeProject
//
//  Created by Tamara Andonovska on 6/1/24.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // We add this code after removing Main from info plist
        // so that we use uikit instead of storyboard
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        let vc = CalculatorViewController()
        window.rootViewController = vc
        self.window = window
        window.makeKeyAndVisible()
    }
}

