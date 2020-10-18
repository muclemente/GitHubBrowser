//
//  UserRepositoryCell.swift
//  Features
//
//  Created by Murilo Clemente on 17/10/2020.
//

import Core
import RxCocoa
import RxDataSources
import RxSwift

class UserRepositoryCell: UITableViewCell, ReusableView {
    // MARK: UIView lifecycle
    override func didMoveToSuperview() {
        setupCell()
        addSubviews()
        addConstraints()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
    }

    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy"
        return formatter
    }()

    // MARK: Private properties
    private lazy var repoNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 21, weight: .thin)
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        label.adjustsFontSizeToFitWidth = false
        return label
    }()

    private lazy var repoDescriptionlabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        label.lineBreakMode = .byTruncatingTail
        label.adjustsFontSizeToFitWidth = false
        return label
    }()

    private lazy var lastUpdatedLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = .darkGray
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var statsView: RepositoryStatsView = {
        let view = RepositoryStatsView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    // MARK: Private methods

    private func addSubviews() {
        contentView.addSubview(repoNameLabel)
        contentView.addSubview(repoDescriptionlabel)
        contentView.addSubview(lastUpdatedLabel)
        contentView.addSubview(statsView)
    }

    private func addConstraints() {
        let margin = UIConstants.defaultMargin

        activateConstraints([
            repoNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: margin * 2),
            repoNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: margin),
            repoNameLabel.widthAnchor.constraint(equalToConstant: UIConstants.labelWidth)
        ])

        activateConstraints([
            repoDescriptionlabel.topAnchor.constraint(equalTo: repoNameLabel.bottomAnchor, constant: margin),
            repoDescriptionlabel.leadingAnchor.constraint(equalTo: repoNameLabel.leadingAnchor),
            repoDescriptionlabel.widthAnchor.constraint(equalToConstant: UIConstants.labelWidth)
        ])

        activateConstraints([
            lastUpdatedLabel.topAnchor.constraint(equalTo: repoDescriptionlabel.bottomAnchor, constant: margin),
            lastUpdatedLabel.leadingAnchor.constraint(equalTo: repoNameLabel.leadingAnchor),
            lastUpdatedLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -margin)
        ])

        activateConstraints([
            statsView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: margin * 2),
            statsView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -margin * 2),
            statsView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -margin * 2)
        ])
    }

    private func setupCell() {
        selectionStyle = .none
    }

    // MARK: Public methods
    func update(_ repository: Repository) {
        statsView.update(repository)
        repoNameLabel.text = repository.name
        repoDescriptionlabel.text = repository.description
        lastUpdatedLabel.text = dateFormatter.string(from: repository.updatedDate)
    }
}

extension UserRepositoryCell {
    struct UIConstants {
        static let labelWidthRatio: CGFloat = 0.7
        static let stackWidthRatio: CGFloat = 0.15
        static let marginRatio: CGFloat = 0.02
        static let spacingRatio: CGFloat = 0.08
        static var defaultMargin: CGFloat {
            ceil(UIScreen.main.bounds.width * marginRatio)
        }
        static var defaultSpacing: CGFloat {
            ceil(UIScreen.main.bounds.width * spacingRatio)
        }
        static var labelWidth: CGFloat {
            ceil(UIScreen.main.bounds.width * labelWidthRatio)
        }
        static var stackWidth: CGFloat {
            ceil(UIScreen.main.bounds.width * stackWidthRatio)
        }
    }
}
