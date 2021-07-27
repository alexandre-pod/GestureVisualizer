//
//  SceneDelegate.swift
//  TouchesVisualizer
//
//  Created by Alexandre Podlewski on 18/07/2021.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        installRootViewController()
        window?.makeKeyAndVisible()
    }

    // MARK: - Private

    private func installRootViewController() {
#if DEBUG
        if
            let screenshotScenario = ProcessInfo.processInfo.environment["screenshot"],
            let scenario = ScreenshotScenario(fromEnvironment: screenshotScenario)
        {
            window?.rootViewController = ScreenshotsScenarioViewController(scenario)
        } else {
            window?.rootViewController = ViewController()
        }
#else
        window?.rootViewController = ViewController()
#endif
    }
}
