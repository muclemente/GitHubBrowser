//
//  MockRequestProvider.swift
//  UnitTests
//
//  Created by Murilo Clemente on 16/10/2020.
//

@testable import Core
import RxSwift

public class MockRequestProvider: RequestProvider {
    public init() { }

    public private(set) var fetchCallCount = 0
    public var fetchHandler: ((Endpoint, CVarArg...) -> (Observable<RequestResponse>))?
    public func fetch(endpoint: Endpoint, args: CVarArg...) -> Observable<RequestResponse> {
        fetchCallCount += 1
        if let fetchHandler = fetchHandler {
            return fetchHandler(endpoint, args)
        }
        return Observable<RequestResponse>.empty()
    }

    public private(set) var fetchUrlCallCount = 0
    public var fetchUrlHandler: ((URL) -> (Observable<RequestResponse>))?
    public func fetch(url: URL) -> Observable<RequestResponse> {
        fetchUrlCallCount += 1
        if let fetchUrlHandler = fetchUrlHandler {
            return fetchUrlHandler(url)
        }
        return Observable<RequestResponse>.empty()
    }
}

