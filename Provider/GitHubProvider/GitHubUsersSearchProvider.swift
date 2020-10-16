//
//  GitHubUsersSearchProvider.swift
//  Provider
//
//  Created by Murilo Clemente on 14/10/2020.
//

import Core
import Foundation
import RxSwift

public class GitHubUsersSearchProvider: UsersSearchProvider {
    private let networkProvider = DependencyManager.resolve(RequestProvider.self)
    private let decoder = JSONDecoder()

    public init() {
    }

    public func fetch(searchTerm: String) -> Observable<[User]> {
        networkProvider.fetch(endpoint: .searchUsers, args: searchTerm, 100).flatMap { (_: HTTPURLResponse, data: Data) -> Observable<[User]> in
            let users = try self.decoder.decode(SearchResult<User>.self, from: data)
            return .just(users.items)
        }
    }
}
