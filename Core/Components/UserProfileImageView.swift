//
//  UserProfileImageView.swift
//  Features
//
//  Created by Murilo Clemente on 15/10/2020.
//

import UIKit

public final class UserProfileImageView: UIImageView {
    // MARK: Public properties

    public lazy var loadingMask: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.alpha = 0.7
        view.isHidden = true
        return view
    }()

    public lazy var spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .gray)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        return spinner
    }()

    // MARK: UIView overrides

    override public func didMoveToSuperview() {
        addSubviews()
        addConstraints()
    }

    override public func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.width / 2
        layer.masksToBounds = true
    }

    // MARK: Private methods

    private func addSubviews() {
        addSubview(loadingMask)
        addSubview(spinner)
    }

    private func addConstraints() {
        loadingMask.constrainToSuperviewBounds()
        spinner.centerInSuperview()
    }
}
