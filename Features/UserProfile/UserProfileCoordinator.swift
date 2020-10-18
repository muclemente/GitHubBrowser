//
//  UserProfileCoordinator.swift
//  Features
//
//  Created by Murilo Clemente on 18/10/2020.
//

import Core
import UIKit

class UserProfileCoordinator: Coordinator {
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
        let userProfileViewModel = UserProfileViewModel(user: user)
        userProfileViewModel.navigationDelegate = self
        let controller = UserProfileViewController(viewModel: userProfileViewModel)
        navigationController.pushViewController(controller, animated: true)
    }
}

extension UserProfileCoordinator: UserProfileNavigationDelegate {
    func didTapBack() {
        navigationController.popViewController(animated: true)
        isCompleted?()
    }
}
