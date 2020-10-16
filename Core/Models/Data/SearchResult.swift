//
//  SearchResult.swift
//  Core
//
//  Created by Murilo Clemente on 14/10/2020.
//

import Foundation

public struct SearchResult<T: Codable>: Codable {
    private enum CodingKeys: String, CodingKey {
        case total = "total_count"
        case incompleteResults = "incomplete_results"
        case items
    }

    public let total: Int
    public let incompleteResults: Bool
    public let items: [T]
}
