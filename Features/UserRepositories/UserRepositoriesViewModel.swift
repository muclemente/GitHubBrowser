//
//  UserRepositoriesViewModel.swift
//  Features
//
//  Created by Murilo Clemente on 17/10/2020.
//

import Core
import RxCocoa
import RxDataSources
import RxSwift

protocol UserRepositoryNavigationDelegate: AnyObject {
    func didTapBack()
    func didTapProfile()
}

class UserRepositoriesViewModel {
    private lazy var provider = DependencyManager.resolve(UserRepositoriesProvider.self)
    private var loadingPublish: PublishSubject<Bool> = PublishSubject()
    private var dataEmptyPublish: PublishSubject<Bool> = PublishSubject()

    var loading: Driver<Bool>
    var dataEmpty: Driver<Bool>
    var user: User
    weak var navigationDelegate: UserRepositoryNavigationDelegate?

    init(user: User) {
        self.user = user
        self.loading = loadingPublish.asDriver(onErrorJustReturn: false)
        self.dataEmpty = dataEmptyPublish.asDriver(onErrorJustReturn: false)
    }

    func fetchRepositories() -> Driver<[Repository]> {
        loadingPublish.onNext(true)
        return provider.fetch(user: user)
            .do(onNext: validateEmptyData)
            .do(onDispose: { [weak self] in self?.loadingPublish.onNext(false) })
            .asDriver(onErrorJustReturn: [])
    }

    func didTapBack() {
        navigationDelegate?.didTapBack()
    }

    func didTapProfile() {
        navigationDelegate?.didTapProfile()
    }

    private func validateEmptyData(_ data: [Repository]) {
        self.dataEmptyPublish.onNext(data.isEmpty)
    }
}
