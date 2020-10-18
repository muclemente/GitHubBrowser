//
//  UserListSection.swift
//  Features
//
//  Created by Murilo Clemente on 16/10/2020.
//

import Core
import RxCocoa
import RxDataSources
import RxSwift

struct UserListSection: SectionModelType {
    var items: [Item]
    typealias Item = User

    init(original: UserListSection, items: [Item]) {
        self = original
        self.items = items
    }

    init(users: [User]) {
        self.items = users
    }
}
