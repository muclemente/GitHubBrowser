//
//  GitHubUserProfileProvider.swift
//  Provider
//
//  Created by Murilo Clemente on 18/10/2020.
//

import Core
import Foundation
import RxSwift

public class GitHubUserProfileProvider: UserProfileProvider {
    private let networkProvider = DependencyManager.resolve(RequestProvider.self)
    private let decoder = JSONDecoder()

    public init() {
    }

    public func fetch(user: User) -> Observable<User> {
        networkProvider.fetch(endpoint: .userProfile, args: user.login).flatMap { (_: HTTPURLResponse, data: Data) -> Observable<User> in
            let user = try self.decoder.decode(User.self, from: data)
            return .just(user)
        }
    }
}
