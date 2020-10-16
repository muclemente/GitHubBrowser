//
//  ImageLoadError.swift
//  Core
//
//  Created by Murilo Clemente on 15/10/2020.
//

import Foundation

public enum ImageLoadError: Error {
    case noCacheDirectory
    case directoryCreation
    case badImageData
}
