//
//  UserSearchViewModel.swift
//  Features
//
//  Created by Murilo Clemente on 14/10/2020.
//

import Core
import RxCocoa
import RxDataSources
import RxSwift

struct UserSection: SectionModelType {
    var items: [Item]
    typealias Item = User

    init(original: UserSection, items: [Item]) {
        self = original
        self.items = items
    }

    init(users: [User]) {
        self.items = users
    }
}

protocol UserListViewModelable {
    var loading: PublishSubject<Bool> { get set }
    var usersSection: PublishSubject<[UserSection]> { get set }
}

class UserSearchViewModel: UserListViewModelable {
    private let provider = DependencyManager.resolve(UsersSearchProvider.self)

    var loading: PublishSubject<Bool> = PublishSubject()
    var usersSection: PublishSubject<[UserSection]> = PublishSubject()
    var searchTerm: String?

    func handleSearchControllerTextChange(text: String?) throws -> Observable<[User]> {
        searchTerm = text
        guard let searchTerm = text,
              searchTerm.count > 2 else {
            return .just([])
        }
        loading.onNext(true)
        return provider.fetch(searchTerm: searchTerm)
    }

    func handleFetchUserEvent(event: Event<[User]>) {
        switch event {
        case .next(let users):
            self.processUserResults(users: users)
        case .completed:
            print("finished")
        case .error(let error):
            self.usersSection.onError(error)
        }
        loading.onNext(false)
    }

    private func processUserResults(users: [User]) {
        let section = UserSection(users: users)
        self.usersSection.onNext([section])
    }
}
