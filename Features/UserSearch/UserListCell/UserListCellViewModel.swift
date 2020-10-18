//
//  UserListCellViewModel.swift
//  Features
//
//  Created by Murilo Clemente on 15/10/2020.
//

import Core
import RxCocoa
import RxDataSources
import RxSwift

protocol UserSearchNavigationDelegate: AnyObject {
    func didSelect(user: User)
}

class UserListCellViewModel {
    private let profileImageProvider = DependencyManager.resolve(UserProfileImageProvider.self)

    var loading: Driver<Bool>
    var username: Driver<String>
    private var loadingPublish: PublishSubject<Bool> = PublishSubject()
    private var usernamePublish: PublishSubject<String> = PublishSubject()

    init() {
        loading = loadingPublish.asDriver(onErrorJustReturn: false)
        username = usernamePublish.asDriver(onErrorJustReturn: "-")
    }

    func updateUser(_ user: User) -> Driver<UIImage> {
        usernamePublish.onNext(user.login)
        loadingPublish.onNext(true)
        return profileImageProvider.fetch(url: user.avatarUrl).do(onDispose: { [weak self] in
            self?.loadingPublish.onNext(false)
        }).asDriver(onErrorJustReturn: UIImage(named: "cloud_error_icon") ?? UIImage())
    }
}
