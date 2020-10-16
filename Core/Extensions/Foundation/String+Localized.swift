//
//  String+Localized.swift
//  Core
//
//  Created by Murilo Clemente on 14/10/2020.
//

import Foundation

public extension String {
    var localized: String {
        NSLocalizedString(self, comment: "")
    }
}
