//
//  GitHubUserRepositoriesProvider.swift
//  Provider
//
//  Created by Murilo Clemente on 17/10/2020.
//

import Core
import Foundation
import RxSwift

public class GitHubUserRepositoriesProvider: UserRepositoriesProvider {
    private let networkProvider = DependencyManager.resolve(RequestProvider.self)
    private let decoder = JSONDecoder()
    private lazy var formatter: DateFormatter = {
        let formatter = DateFormatter()
        let dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = dateFormat
        return formatter
    }()

    public init() {
        decoder.dateDecodingStrategy = .formatted(formatter)
    }

    public func fetch(user: User) -> Observable<[Repository]> {
        networkProvider.fetch(endpoint: .userRepositories, args: user.login).flatMap { (_: HTTPURLResponse, data: Data) -> Observable<[Repository]> in
            let repositories = try self.decoder.decode([Repository].self, from: data)
            return .just(repositories)
        }
    }
}
