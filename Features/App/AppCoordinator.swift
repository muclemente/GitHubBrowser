//
//  AppCoordinator.swift
//  Features
//
//  Created by Murilo Clemente on 14/10/2020.
//

import Foundation
import UIKit

public final class AppCoordinator: Coordinator {
    // MARK: Private variables
    private let window: UIWindow
    private let navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    var isCompleted: (() -> Void)?

    // MARK: Public
    public init() {
        window = UIWindow(frame: UIScreen.main.bounds)
        navigationController = UINavigationController()
    }

    public func start() {
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        window.backgroundColor = .white
        presentUserSearchCoordinator()
    }

    // MARK: Private methods

    private func presentUserSearchCoordinator() {
        let controller = UserSearchCoordinator(navigationController: navigationController)
        store(coordinator: controller)
        controller.start()
    }
}
