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

class UserSearchViewModel {
    private lazy var provider = DependencyManager.resolve(UsersSearchProvider.self)
    private var loadingPublish: PublishSubject<Bool> = PublishSubject()
    private var dataEmptyPublish: PublishSubject<Bool> = PublishSubject()

    var loading: Driver<Bool>
    var dataEmpty: Driver<Bool>
    var searchTerm: String?
    weak var navigationDelegate: UserSearchNavigationDelegate?

    init() {
        loading = loadingPublish.asDriver(onErrorJustReturn: false)
        dataEmpty = dataEmptyPublish.asDriver(onErrorJustReturn: false)
    }

    func handleSearchControllerTextChange(text: String?) -> Driver<[UserListSection]> {
        searchTerm = text
        return fetchUsers(searchTerm: searchTerm)
            .do(onNext: validateEmptyData)
    }

    func didSelect(user: User) {
        navigationDelegate?.didSelect(user: user)
    }

    private func validateEmptyData(_ data: [UserListSection]) {
        self.dataEmptyPublish.onNext(data.first?.items.isEmpty ?? true)
    }

    private func fetchUsers(searchTerm: String?) -> Driver<[UserListSection]> {
        guard let searchTerm = searchTerm,
              searchTerm.count > 2 else {
            return .just([UserListSection(users: [])])
        }
        loadingPublish.onNext(true)
        return self.provider.fetch(searchTerm: searchTerm)
            .map { self.processUserResults($0) }
            .do(onDispose: { self.loadingPublish.onNext(false) })
            .asDriver(onErrorJustReturn: [])
    }

    private func processUserResults(_ users: [User]) -> [UserListSection] {
        let section = UserListSection(users: users)
        return [section]
    }
}
