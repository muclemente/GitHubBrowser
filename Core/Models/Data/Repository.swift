//
//  Repository.swift
//  Core
//
//  Created by Murilo Clemente on 17/10/2020.
//

import Foundation

public struct Repository: Codable {
    private enum CodingKeys: String, CodingKey {
        case name
        case id
        case description
        case updatedDate = "updated_at"
        case forkCount = "forks_count"
        case watcherCount = "watchers_count"
        case stargazerCount = "stargazers_count"
    }

    public let name: String
    public let id: Int
    public let description: String?
    public let forkCount: Int
    public let stargazerCount: Int
    public let watcherCount: Int
    public let updatedDate: Date
}
