//
//  UserProfileProvider.swift
//  Core
//
//  Created by Murilo Clemente on 18/10/2020.
//

import Foundation
import RxSwift

/// @mockable
public protocol UserProfileProvider {
    func fetch(user: User) -> Observable<User>
}
