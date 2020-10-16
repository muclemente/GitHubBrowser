//
//  User.swift
//  Core
//
//  Created by Murilo Clemente on 14/10/2020.
//

import Foundation

public struct User: Codable {
    private enum CodingKeys: String, CodingKey {
        case login
        case id
        case nodeId = "node_id"
        case avatarUrl = "avatar_url"
        case url
    }

    public let login: String
    public let id: Int
    public let nodeId: String
    public let avatarUrl: URL
    public let url: URL
}

extension User: Equatable {
    public static func == (lhs: User, rhs: User) -> Bool {
        lhs.login == rhs.login
    }
}
