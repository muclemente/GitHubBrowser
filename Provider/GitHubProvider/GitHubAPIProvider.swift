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

    public init() {
    }

    static let username = "muclemente"
    static let accessToken = "926f35da3de262d8bbb0ddb47abe3a11b43f82ef"

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
        guard let auth = "\(GitHubAPIProvider.username):\(GitHubAPIProvider.accessToken)".data(using: String.Encoding.utf8) else {
            return ""
        }
        return "Basic \(auth.base64EncodedString())"
    }
}
