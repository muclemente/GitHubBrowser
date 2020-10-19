//
//  XCTestCase+Wait.swift
//  UnitTests
//
//  Created by Murilo Clemente on 18/10/2020.
//

import XCTest

extension XCTestCase {
    func wait(timeout: TimeInterval) {
        let exp = expectation(description: UUID().uuidString)
        _ = XCTWaiter.wait(for: [exp], timeout: timeout)
    }
}
