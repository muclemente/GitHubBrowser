//
//  User+Tests.swift
//  UnitTests
//
//  Created by Murilo Clemente on 16/10/2020.
//

import Foundation
@testable import Core

extension User {
    init(id: Int, login: String) {
        let url = URL(string: "file://")!
        self.init(id: id, login: login, nodeId: "", avatarUrl: url)
    }
}
