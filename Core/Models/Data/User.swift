//
//  User.swift
//  Core
//
//  Created by Murilo Clemente on 14/10/2020.
//

import Foundation

public struct UserDetails: Codable {
    private enum CodingKeys: String, CodingKey {
        case name
        case company
        case location
        case email
        case bio
        case publicRepos = "public_repos"
        case publicGists = "public_gists"
        case followers
        case following
    }
    public let name: String
    public let company: String?
    public let location: String?
    public let email: String?
    public let bio: String?
    public let publicRepos: Int
    public let publicGists: Int
    public let followers: Int
    public let following: Int

    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try values.decode(String.self, forKey: .name)
        self.company = try? values.decode(String.self, forKey: .company)
        self.location = try? values.decode(String.self, forKey: .location)
        self.email = try? values.decode(String.self, forKey: .email)
        self.bio = try? values.decode(String.self, forKey: .bio)
        self.publicRepos = try values.decode(Int.self, forKey: .publicRepos)
        self.publicGists = try values.decode(Int.self, forKey: .publicGists)
        self.followers = try values.decode(Int.self, forKey: .followers)
        self.following = try values.decode(Int.self, forKey: .following)
    }
}

public struct User: Codable {
    private enum CodingKeys: String, CodingKey {
        case login
        case id
        case nodeId = "node_id"
        case avatarUrl = "avatar_url"
    }

    public let login: String
    public let id: Int
    public let nodeId: String
    public let avatarUrl: URL
    public let details: UserDetails?

    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.login = try values.decode(String.self, forKey: .login)
        self.id = try values.decode(Int.self, forKey: .id)
        self.nodeId = try values.decode(String.self, forKey: .nodeId)
        self.avatarUrl = try values.decode(URL.self, forKey: .avatarUrl)
        self.details = try? UserDetails(from: decoder)
    }

    public init(id: Int,
                login: String,
                nodeId: String,
                avatarUrl: URL,
                details: UserDetails? = nil) {
        self.login = login
        self.nodeId = nodeId
        self.id = id
        self.avatarUrl = avatarUrl
        self.details = details
    }
}
