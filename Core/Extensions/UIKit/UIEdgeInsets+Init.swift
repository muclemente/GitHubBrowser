//
//  UIEdgeInsets+Init.swift
//  Core
//
//  Created by Murilo Clemente on 14/10/2020.
//

import UIKit

public extension UIEdgeInsets {
    init(horizontal: CGFloat, vertical: CGFloat) {
        self.init(top: vertical, left: horizontal, bottom: vertical, right: horizontal)
    }
}
