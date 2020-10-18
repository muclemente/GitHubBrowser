//
//  UserSearchCoordinator.swift
//  Features
//
//  Created by Murilo Clemente on 14/10/2020.
//

import Core
import UIKit

class UserSearchCoordinator: Coordinator {
    // MARK: Private variables
    private let navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    var isCompleted: (() -> Void)?

    // MARK: Public methods
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let userSearchViewModel = UserSearchViewModel()
        userSearchViewModel.navigationDelegate = self
        let controller = UserSearchViewController(viewModel: userSearchViewModel)
        navigationController.pushViewController(controller, animated: true)
    }

    func navigateToRepositoryList(selectedUser: User) {
        let repoCoordinator = UserRepositoriesCoordinator(navigationController: navigationController, user: selectedUser)
        repoCoordinator.isCompleted = { [weak self] in
            self?.free(coordinator: repoCoordinator)
        }
        store(coordinator: repoCoordinator)
        repoCoordinator.start()
    }
}

extension UserSearchCoordinator: UserSearchNavigationDelegate {
    func didSelect(user: User) {
        navigateToRepositoryList(selectedUser: user)
    }
}
