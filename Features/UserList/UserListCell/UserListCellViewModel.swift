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

class UserListCellViewModel {
    let profileImageProvider = DependencyManager.resolve(UserProfileImageProvider.self)

    var username: PublishSubject<String> = PublishSubject()
    var profileImage: PublishSubject<UIImage?> = PublishSubject()

    func updateUser(_ user: User) -> Observable<UIImage> {
        username.onNext(user.login)
        return profileImageProvider.fetch(url: user.avatarUrl)
    }

    func handleProfileImageEvent(event: Event<UIImage>) {
        switch event {
        case .next(let image):
            profileImage.onNext(image)
        case .error(let error):
            profileImage.onError(error)
        default:
            break
        }
    }
}
