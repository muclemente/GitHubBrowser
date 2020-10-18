//
//  MockURLProvider.swift
//  UnitTests
//
//  Created by Murilo Clemente on 16/10/2020.
//

@testable import Core
import RxSwift

public class MockURLProvider: URLProvider {
    public init() { }

    public private(set) var urlCallCount = 0
    public var urlHandler: ((Endpoint, [CVarArg]) -> (URL?))?
    public func url(endpoint: Endpoint, with args: [CVarArg]) -> URL? {
        urlCallCount += 1
        if let urlHandler = urlHandler {
            return urlHandler(endpoint, args)
        }
        return nil
    }
}
