//
//  AppConstants.swift
//  Core
//
//  Created by Murilo Clemente on 14/10/2020.
//

import Foundation
import RxSwift

public struct AppConstants {
    /// Default value for RX debounce timer in text inputs
    public static let inputDebounceTimer: RxTimeInterval = .milliseconds(300)
    /// Default value for request retrying
    public static let requestRetryAttempts = 3
}
