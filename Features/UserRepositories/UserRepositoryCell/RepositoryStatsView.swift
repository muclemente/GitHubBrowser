//
//  RepositoryStatsView.swift
//  Features
//
//  Created by Murilo Clemente on 17/10/2020.
//

import Core
import UIKit

class RepositoryStatsView: UIView {

    private lazy var stack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.distribution = .equalSpacing
        stack.spacing = 10
        return stack
    }()

    private lazy var forkCountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .darkGray
        return label
    }()

    private lazy var watcherCountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .darkGray
        return label
    }()

    private lazy var stargazerCountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .darkGray
        return label
    }()

    private func textWithIcon(iconName: String, text: String) -> NSAttributedString {
        let icon = UIImage(named: iconName)
        let attachment = NSTextAttachment()
        attachment.image = icon
        attachment.bounds = CGRect(
            x: UIConstants.iconX,
            y: UIConstants.iconY,
            width: UIConstants.iconSize,
            height: UIConstants.iconSize
        )
        let attachString = NSAttributedString(attachment: attachment)
        let attributedString = NSMutableAttributedString()
        attributedString.append(attachString)
        attributedString.append(NSAttributedString(string: text))
        return attributedString
    }

    override func didMoveToSuperview() {
        addSubviews()
        addConstraints()
    }

    private func addSubviews() {
        addSubview(stack)
        stack.addArrangedSubview(forkCountLabel)
        stack.addArrangedSubview(watcherCountLabel)
        stack.addArrangedSubview(stargazerCountLabel)
    }

    private func addConstraints() {
        stack.constrainToSuperviewBounds()
    }

    func update(_ repo: Repository) {
        forkCountLabel.attributedText = textWithIcon(iconName: "fork_icon", text: " \(repo.forkCount)")
        watcherCountLabel.attributedText = textWithIcon(iconName: "eye_icon", text: " \(repo.watcherCount)")
        stargazerCountLabel.attributedText = textWithIcon(iconName: "star_icon", text: " \(repo.stargazerCount)")
    }
}

extension RepositoryStatsView {
    struct UIConstants {
        static let iconX = CGFloat(0)
        static let iconY = CGFloat(-2)
        static let iconSize = CGFloat(15)
    }
}
