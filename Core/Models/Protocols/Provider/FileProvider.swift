//
//  FileProvider.swift
//  Core
//
//  Created by Murilo Clemente on 15/10/2020.
//

import Foundation
import RxSwift

/// @mockable
public protocol FileProvider {
    func fetch(fileName: String) throws -> UIImage
    func save(fileName: String, data: Data) throws
}
