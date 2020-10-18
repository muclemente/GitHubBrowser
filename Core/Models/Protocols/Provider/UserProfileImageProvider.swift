//
//  UserProfileImageProvider.swift
//  Core
//
//  Created by Murilo Clemente on 15/10/2020.
//

import Foundation
import RxSwift

/// @mockable
public protocol UserProfileImageProvider {
    func fetch(url: URL) -> Observable<UIImage>
}
