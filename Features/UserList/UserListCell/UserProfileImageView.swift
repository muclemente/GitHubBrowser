//
//  UserProfileImageView.swift
//  Features
//
//  Created by Murilo Clemente on 15/10/2020.
//

import UIKit

final class UserProfileImageView: UIImageView {

    // MARK: UIView overrides

    override func didMoveToSuperview() {
        addSubviews()
        addConstraints()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.width / 2
        layer.masksToBounds = true
    }

    // MARK: Private properties

    private lazy var spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .gray)
        spinner.hidesWhenStopped = true
        spinner.translatesAutoresizingMaskIntoConstraints = false
        return spinner
    }()

    // MARK: Public properties

    var loadingSpinner: UIActivityIndicatorView { spinner }

    // MARK: Private methods

    private func addSubviews() {
        addSubview(spinner)
    }

    private func addConstraints() {
        spinner.centerInSuperview()
    }
}
