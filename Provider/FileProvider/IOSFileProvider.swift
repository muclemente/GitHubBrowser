//
//  IOSFileProvider.swift
//  Provider
//
//  Created by Murilo Clemente on 15/10/2020.
//

import Core
import Foundation
import RxSwift

public class IOSFileProvider: FileProvider {
    // MARK: Private properties
    private let imagesDirectoryPath = "images"

    // MARK: Public methods
    public init() {
    }

    public func fetch(fileName: String) throws -> UIImage {
        let imageDirectoryURL = try imageDirectory()
        let imageURL = imageDirectoryURL.appendingPathComponent(fileName)
        let data = try Data(contentsOf: imageURL)
        guard let image = UIImage(data: data) else {
            throw ImageLoadError.badImageData
        }
        return image
    }

    public func save(fileName: String, data: Data) throws {
        let imageDirectoryURL = try imageDirectory()
        let imageWriteURL = imageDirectoryURL.appendingPathComponent(fileName)
        try data.write(to: imageWriteURL)
    }

    // MARK: Private methods

    private func imageDirectory() throws -> URL {
        guard let cachesDirectoryPath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first else {
            throw ImageLoadError.noCacheDirectory
        }
        let cachesDirectoryUrl = URL(fileURLWithPath: cachesDirectoryPath)
        let imagesDirectory = cachesDirectoryUrl.appendingPathComponent(imagesDirectoryPath)

        do {
            try FileManager.default.createDirectory(at: imagesDirectory, withIntermediateDirectories: true, attributes: nil)
        } catch {
            throw ImageLoadError.directoryCreation
        }

        return imagesDirectory
    }
}
