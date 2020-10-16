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
        bind()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        backgroundColor = .white
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
        label.font = UIFont.preferredFont(forTextStyle: .body)
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
        activateConstraints([
            userProfileImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: margin),
            userProfileImageView.leadingAnchor.constraint(equalTo: contentView.readableContentGuide.leadingAnchor),
            userProfileImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -margin)
        ])

        userProfileImageView.constrainSize(to: UIConstants.pictureSize)

        activateConstraints([
            usernameLabel.topAnchor.constraint(equalTo: userProfileImageView.topAnchor),
            usernameLabel.leadingAnchor.constraint(equalTo: userProfileImageView.trailingAnchor, constant: UIConstants.defaultSpacing)
        ])
    }

    private func bind() {
        viewModel.username.bind(to: usernameLabel.rx.text).disposed(by: disposeBag)
        viewModel.profileImage.bind(to: userProfileImageView.rx.image).disposed(by: disposeBag)
    }

    private func setupCell() {
        selectionStyle = .none
    }

    // MARK: Public methods
    func update(_ user: User) {
        bind()
        viewModel.updateUser(user).observeOn(MainScheduler.instance).subscribe(viewModel.handleProfileImageEvent).disposed(by: disposeBag)
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
