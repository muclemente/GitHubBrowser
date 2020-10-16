//
//  GitHubUserProfileImageProvider.swift
//  Provider
//
//  Created by Murilo Clemente on 15/10/2020.
//

import Core
import Foundation
import RxSwift
import UIKit

public class GitHubUserProfileImageProvider: UserProfileImageProvider {
    private let networkProvider = DependencyManager.resolve(RequestProvider.self)
    private let fileProvider = DependencyManager.resolve(FileProvider.self)
    private let decoder = JSONDecoder()

    public init() {
    }

    public func fetch(url: URL) -> Observable<UIImage> {
        let imageId = url.pathComponents.last

        if let fileName = imageId,
           let cachedImage = try? fileProvider.fetch(fileName: fileName) {
            return .just(cachedImage)
        }

        return networkProvider.fetch(url: url).flatMap { (_: HTTPURLResponse, data: Data) -> Observable<UIImage> in
            guard let image = UIImage(data: data) else {
                return .error(NetworkError.invalidData)
            }
            if let imageName = imageId {
                try? self.fileProvider.save(fileName: imageName, data: data)
            }
            return .just(image)
        }
    }
}
