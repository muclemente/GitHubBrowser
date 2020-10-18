//
//  UserProfileViewModel.swift
//  Features
//
//  Created by Murilo Clemente on 18/10/2020.
//

import Core
import RxCocoa
import RxDataSources
import RxSwift

protocol UserProfileNavigationDelegate: AnyObject {
    func didTapBack()
}

class UserProfileViewModel {
    private lazy var provider = DependencyManager.resolve(UserProfileProvider.self)
    private lazy var profileImageProvider = DependencyManager.resolve(UserProfileImageProvider.self)
    private var loadingPublish: PublishSubject<Bool> = PublishSubject()

    var loading: Driver<Bool>
    var user: User
    weak var navigationDelegate: UserProfileNavigationDelegate?

    init(user: User) {
        self.user = user
        self.loading = loadingPublish.asDriver(onErrorJustReturn: false)
    }

    func fetch() -> Observable<UserDetails> {
        self.loadingPublish.onNext(true)
        return provider.fetch(user: user)
            .flatMap(self.validateProfileData)
            .do(onDispose: {
                self.loadingPublish.onNext(false)
            })
    }

    func fetchImage() -> Driver<UIImage> {
        profileImageProvider
            .fetch(url: user.avatarUrl)
            .asDriver(onErrorJustReturn: UIImage(named: "cloud_error_icon") ?? UIImage())
    }

    private func validateProfileData(user: User) -> Observable<UserDetails> {
        guard let details = user.details else {
            return .error(NetworkError.invalidData)
        }
        return .just(details)
    }

    func didTapBack() {
        navigationDelegate?.didTapBack()
    }
}
