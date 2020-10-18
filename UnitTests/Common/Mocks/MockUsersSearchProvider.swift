//
//  MockUsersSearchProvider.swift
//  UnitTests
//
//  Created by Murilo Clemente on 16/10/2020.
//

@testable import Core
import RxSwift

public class MockUsersSearchProvider: UsersSearchProvider {
    public init() { }

    public private(set) var fetchCallCount = 0
    public var fetchHandler: ((String) -> (Observable<[User]>))?
    public func fetch(searchTerm: String) -> Observable<[User]> {
        fetchCallCount += 1
        if let fetchHandler = fetchHandler {
            return fetchHandler(searchTerm)
        }
        return Observable<[User]>.empty()
    }
}
