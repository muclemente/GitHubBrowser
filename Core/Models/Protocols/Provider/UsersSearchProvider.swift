//
//  UsersProvider.swift
//  Core
//
//  Created by Murilo Clemente on 14/10/2020.
//

import Foundation
import RxSwift

/// @mockable
public protocol UsersSearchProvider {
    func fetch(searchTerm: String) -> Observable<[User]>
}
