//
//  AppDelegate.swift
//  App
//
//  Created by Murilo Clemente on 14/10/2020.
//

import Core
import Features
import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    private var appCoodinator: AppCoordinator?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        DependencyInjector.load()
        appCoodinator = AppCoordinator()
        appCoodinator?.start()
        return true
    }
}
