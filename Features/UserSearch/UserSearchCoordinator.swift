//
//  UserSearchCoordinator.swift
//  Features
//
//  Created by Murilo Clemente on 14/10/2020.
//

import UIKit

class UserSearchCoordinator {
    // MARK: Private variables
    private let navigationController: UINavigationController

    // MARK: Public methods
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let userSearchViewModel = UserSearchViewModel()
        let controller = UserSearchViewController(viewModel: userSearchViewModel)
        navigationController.pushViewController(controller, animated: true)
    }
}
