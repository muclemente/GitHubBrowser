//
//  UserRepositoriesCoordinator.swift
//  Features
//
//  Created by Murilo Clemente on 17/10/2020.
//

import Core
import UIKit

class UserRepositoriesCoordinator: Coordinator {
    // MARK: Private variables
    private let navigationController: UINavigationController
    private var user: User
    var childCoordinators: [Coordinator] = []
    var isCompleted: (() -> Void)?

    // MARK: Public methods
    init(navigationController: UINavigationController,
         user: User) {
        self.user = user
        self.navigationController = navigationController
    }

    func start() {
        let userRepoViewModel = UserRepositoriesViewModel(user: user)
        userRepoViewModel.navigationDelegate = self
        let controller = UserRepositoriesViewController(viewModel: userRepoViewModel)
        navigationController.pushViewController(controller, animated: true)
    }

    func navigateToProfile() {
        let profileCoordinator = UserProfileCoordinator(navigationController: navigationController, user: user)
        profileCoordinator.isCompleted = { [weak self] in
            self?.free(coordinator: profileCoordinator)
        }
        store(coordinator: profileCoordinator)
        profileCoordinator.start()
    }
}

extension UserRepositoriesCoordinator: UserRepositoryNavigationDelegate {
    func didTapBack() {
        navigationController.popViewController(animated: true)
        isCompleted?()
    }

    func didTapProfile() {
        navigateToProfile()
    }
}
