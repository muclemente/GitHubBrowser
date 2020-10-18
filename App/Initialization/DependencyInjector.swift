//
//  DependencyInjector.swift
//  App
//
//  Created by Murilo Clemente on 14/10/2020.
//

import Core
import Foundation
import Provider

class DependencyInjector {
    static func load() {
        DependencyManager.register(UsersSearchProvider.self) {
            GitHubUsersSearchProvider()
        }

        DependencyManager.register(URLProvider.self) {
            GitHubURLProvider()
        }

        DependencyManager.register(RequestProvider.self) {
            GitHubAPIProvider()
        }

        DependencyManager.register(UserProfileImageProvider.self) {
            GitHubUserProfileImageProvider()
        }

        DependencyManager.register(FileProvider.self) {
            IOSFileProvider()
        }

        DependencyManager.register(UserRepositoriesProvider.self) {
            GitHubUserRepositoriesProvider()
        }

        DependencyManager.register(UserProfileProvider.self) {
            GitHubUserProfileProvider()
        }
    }
}
