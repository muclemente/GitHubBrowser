//
//  URLProvider.swift
//  Core
//
//  Created by Murilo Clemente on 14/10/2020.
//

import Foundation

public protocol URLProvider {
    func url(endpoint: Endpoint, with args: [CVarArg]) -> URL?
}
