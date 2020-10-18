//
//  Driver+Operators.swift
//  Core
//
//  Created by Murilo Clemente on 17/10/2020.
//

import RxCocoa

public extension Driver where Element == Bool {
    func inverted() -> Self {
        self.map { !$0 }
    }
}
