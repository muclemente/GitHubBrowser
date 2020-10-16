//
//  GitHubURLProvider.swift
//  Provider
//
//  Created by Murilo Clemente on 14/10/2020.
//

import Core
import Foundation

public class GitHubURLProvider: URLProvider {
    private lazy var plist = {
        Bundle(for: Self.self)
            .path(forResource: "Endpoints", ofType: "plist")
            .map { NSDictionary(contentsOfFile: $0) ?? [:] }
    }()

    public init() {
    }

    public func url(endpoint: Endpoint, with args: [CVarArg]) -> URL? {
        let urlStringFormat = plist?[endpoint.rawValue] as? String ?? ""
        return URL(string: String(format: urlStringFormat, arguments: args))
    }
}
