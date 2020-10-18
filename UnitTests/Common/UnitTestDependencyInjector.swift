//
//  UnitTestDependencyInjector.swift
//  UnitTests
//
//  Created by Murilo Clemente on 16/10/2020.
//

@testable import Core

class UnitTestDependencyInjector {
    static func reset() {
        DependencyManager.clean()
    }

    static func load() {
        let userSearch = MockUsersSearchProvider()
        let url = MockURLProvider()
        let request = MockRequestProvider()
        let profileImage = MockUserProfileImageProvider()
        let userRepositories = MockUserRepositoriesProvider()
        let userProfile = MockUserProfileProvider()

        DependencyManager.register(UsersSearchProvider.self) {
            userSearch
        }

        DependencyManager.register(URLProvider.self) {
            url
        }

        DependencyManager.register(RequestProvider.self) {
            request
        }

        DependencyManager.register(UserProfileImageProvider.self) {
            profileImage
        }

        DependencyManager.register(UserRepositoriesProvider.self) {
            userRepositories
        }

        DependencyManager.register(UserProfileProvider.self) {
            userProfile
        }
    }
}
