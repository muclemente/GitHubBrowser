//
//  UserRepositoriesProvider.swift
//  Core
//
//  Created by Murilo Clemente on 17/10/2020.
//

import Foundation
import RxSwift

/// @mockable
public protocol UserRepositoriesProvider {
    func fetch(user: User) -> Observable<[Repository]>
}
