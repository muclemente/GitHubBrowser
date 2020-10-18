//
//  MockUserRepositoriesProvider.swift
//  UnitTests
//
//  Created by Murilo Clemente on 18/10/2020.
//

import Core
import Foundation
import RxSwift
import UIKit

public class MockUserRepositoriesProvider: UserRepositoriesProvider {
    public init() { }

    public private(set) var fetchCallCount = 0
    public var fetchHandler: ((User) -> (Observable<[Repository]>))?
    public func fetch(user: User) -> Observable<[Repository]> {
        fetchCallCount += 1
        if let fetchHandler = fetchHandler {
            return fetchHandler(user)
        }
        return Observable<[Repository]>.empty()
    }
}
