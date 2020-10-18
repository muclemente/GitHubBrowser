//
//  Coordinator.swift
//  Features
//
//  Created by Murilo Clemente on 17/10/2020.
//

import Foundation

protocol Coordinator: AnyObject {
    var childCoordinators: [Coordinator] { get set }
    var isCompleted: (() -> Void)? { get set }
    func start()
}

extension Coordinator {
    func store(coordinator: Coordinator) {
        childCoordinators.append(coordinator)
    }

    func free(coordinator: Coordinator) {
        childCoordinators = childCoordinators.filter { $0 !== coordinator }
    }
}
