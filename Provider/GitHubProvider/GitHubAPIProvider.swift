//
//  GitHubAPIProvider.swift
//  Provider
//
//  Created by Murilo Clemente on 14/10/2020.
//

import Core
import Foundation
import RxCocoa
import RxRelay
import RxSwift

public class GitHubAPIProvider: RequestProvider {
    private let urlProvider = DependencyManager.resolve(URLProvider.self)
    private lazy var plist = {
        Bundle(for: Self.self)
            .path(forResource: "GithubAPICredentials", ofType: "plist")
            .map { NSDictionary(contentsOfFile: $0) ?? [:] }
    }()

    public init() {
        assert(plist?["User"] != nil,
               "Your GitHub API credentials are not set. Please update the Plist file or run `make user=x token=y project`")
    }

    private var username: String {
        guard let value = plist?["User"] as? String else {
            fatalError("Invalid username")
        }
        return value
    }

    private var accessToken: String {
        guard let value = plist?["Token"] as? String else {
            fatalError("Invalid token")
        }
        return value
    }

    public func fetch(endpoint: Endpoint, args: CVarArg...) -> Observable<RequestResponse> {
        guard let url = urlProvider.url(endpoint: endpoint, with: args) else {
            return .error(NetworkError.invalidData)
        }
        return URLSession.shared.rx.response(request: requestWith(url: url))
            .retry(AppConstants.requestRetryAttempts)
    }

    public func fetch(url: URL) -> Observable<RequestResponse> {
        URLSession.shared.rx.response(request: requestWith(url: url))
            .retry(AppConstants.requestRetryAttempts)
    }

    private func requestWith(url: URL) -> URLRequest {
        var request = URLRequest(url: url)
        request.setValue(authenticationHeader(), forHTTPHeaderField: "Authorization")
        return request
    }

    private func authenticationHeader() -> String {
        guard let auth = "\(username):\(accessToken)".data(using: String.Encoding.utf8) else {
            return ""
        }
        return "Basic \(auth.base64EncodedString())"
    }
}
