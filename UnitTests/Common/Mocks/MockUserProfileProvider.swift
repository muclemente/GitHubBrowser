//
//  MockUserProfileProvider.swift
//  UnitTests
//
//  Created by Murilo Clemente on 18/10/2020.
//

import Core
import Foundation
import RxSwift
import UIKit

public class MockUserProfileProvider: UserProfileProvider {
    public init() { }

    public private(set) var fetchCallCount = 0
    public var fetchHandler: ((User) -> (Observable<User>))?
    public func fetch(user: User) -> Observable<User> {
        fetchCallCount += 1
        if let fetchHandler = fetchHandler {
            return fetchHandler(user)
        }
        return Observable<User>.empty()
    }

    func jsonData(json: String) -> Observable<User> {
        let data = json.data(using: .utf8) ?? Data()
        do {
            let entity = try JSONDecoder().decode(User.self, from: data)
            return .just(entity)
        } catch {
            return .error(error)
        }
    }
}

extension MockUserProfileProvider {

    var detailJSONString: String {
    """
    {
      "login": "octocat",
      "id": 1,
      "node_id": "MDQ6VXNlcjE=",
      "avatar_url": "https://github.com/images/error/octocat_happy.gif",
      "gravatar_id": "",
      "url": "https://api.github.com/users/octocat",
      "type": "User",
      "site_admin": false,
      "name": "monalisa octocat",
      "company": "GitHub",
      "blog": "https://github.com/blog",
      "location": "San Francisco",
      "email": "octocat@github.com",
      "hireable": false,
      "bio": "There once was...",
      "twitter_username": "monatheoctocat",
      "public_repos": 2,
      "public_gists": 1,
      "followers": 20,
      "following": 0,
      "created_at": "2008-01-14T04:33:35Z",
      "updated_at": "2008-01-14T04:33:35Z"
    }
    """
    }

}
