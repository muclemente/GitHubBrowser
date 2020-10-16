//
//  RequestProvider.swift
//  Core
//
//  Created by Murilo Clemente on 14/10/2020.
//

import Foundation
import RxSwift

public typealias RequestResponse = (response: HTTPURLResponse, data: Data)

public protocol RequestProvider {
    func fetch(endpoint: Endpoint, args: CVarArg...) -> Observable<RequestResponse>
    func fetch(url: URL) -> Observable<RequestResponse>
}
