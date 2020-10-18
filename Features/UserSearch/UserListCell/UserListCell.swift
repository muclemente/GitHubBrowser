//
//  UserListCell.swift
//  Features
//
//  Created by Murilo Clemente on 15/10/2020.
//

import Core
import RxCocoa
import RxDataSources
import RxSwift

class UserListCell: UITableViewCell, ReusableView {
    // MARK: UIView lifecycle
    override func didMoveToSuperview() {
        setupCell()
        addSubviews()
        addConstraints()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
        viewModel = UserListCellViewModel()
    }

    // MARK: Private properties

    private var disposeBag = DisposeBag()
    private var viewModel = UserListCellViewModel()

    private lazy var userProfileImageView: UserProfileImageView = {
        let imageView = UserProfileImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private lazy var usernameLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .body)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // MARK: Private methods

    private func addSubviews() {
        contentView.addSubview(userProfileImageView)
        contentView.addSubview(usernameLabel)
    }

    private func addConstraints() {
        let margin = UIConstants.defaultMargin
        let height = userProfileImageView.heightAnchor.constraint(equalToConstant: UIConstants.pictureSize)
        height.priority = .defaultHigh
        activateConstraints([
            userProfileImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: margin),
            userProfileImageView.leadingAnchor.constraint(equalTo: contentView.readableContentGuide.leadingAnchor),
            userProfileImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -margin),
            userProfileImageView.widthAnchor.constraint(equalToConstant: UIConstants.pictureSize),
            height
        ])
        activateConstraints([
            usernameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            usernameLabel.leadingAnchor.constraint(equalTo: userProfileImageView.trailingAnchor, constant: UIConstants.defaultSpacing)
        ])
    }

    private func bind(user: User) {
        viewModel.username
            .drive(usernameLabel.rx.text)
            .disposed(by: disposeBag)
        viewModel.loading
            .drive(userProfileImageView.spinner.rx.isAnimating)
            .disposed(by: disposeBag)
        viewModel.loading
            .inverted()
            .drive(userProfileImageView.loadingMask.rx.isHidden)
            .disposed(by: disposeBag)
        viewModel.updateUser(user)
            .drive(userProfileImageView.rx.image)
            .disposed(by: disposeBag)
    }

    private func setupCell() {
        accessoryType = .disclosureIndicator
        selectionStyle = .none
    }

    // MARK: Public methods
    func update(_ user: User) {
        bind(user: user)
    }
}

extension UserListCell {
    struct UIConstants {
        static let marginRatio: CGFloat = 0.02
        static let spacingRatio: CGFloat = 0.08
        static let pictureSizeRatio: CGFloat = 0.15
        static var defaultMargin: CGFloat {
            ceil(UIScreen.main.bounds.width * marginRatio)
        }
        static var defaultSpacing: CGFloat {
            ceil(UIScreen.main.bounds.width * spacingRatio)
        }
        static var pictureSize: CGFloat {
            ceil(UIScreen.main.bounds.width * pictureSizeRatio)
        }
    }
}
