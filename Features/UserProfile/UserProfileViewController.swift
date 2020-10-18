//
//  UserProfileViewController.swift
//  Features
//
//  Created by Murilo Clemente on 18/10/2020.
//

import Core
import RxCocoa
import RxDataSources
import RxSwift
import UIKit

class UserProfileViewController: UIViewController {
    // MARK: Private properties
    private let viewModel: UserProfileViewModel
    private let disposeBag = DisposeBag()

    // MARK: public methods
    init(viewModel: UserProfileViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private lazy var profileImage: UserProfileImageView = {
        let view = UserProfileImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 18, weight: .thin)
        label.numberOfLines = 1
        label.textColor = .darkText
        return label
    }()

    private lazy var bioLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 12)
        label.numberOfLines = 3
        label.textColor = .darkText
        return label
    }()

    private lazy var spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .gray)
        spinner.hidesWhenStopped = true
        spinner.translatesAutoresizingMaskIntoConstraints = false
        return spinner
    }()

    private lazy var loadingMask: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.alpha = 0.7
        view.isHidden = true
        return view
    }()

    private lazy var errorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isHidden = true
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .darkGray
        return label
    }()

    private lazy var stack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.distribution = .equalSpacing
        stack.spacing = 5
        return stack
    }()

    // MARK: Internal methods
    override func loadView() {
        view = UIView()
        view.backgroundColor = .white
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupController()
        addSubviews()
        addConstraints()
        bind()
    }

    private func addSubviews() {
        view.addSubview(profileImage)
        view.addSubview(nameLabel)
        view.addSubview(bioLabel)
        view.addSubview(stack)

        view.addSubview(errorLabel)
        view.addSubview(loadingMask)
        view.addSubview(spinner)
    }

    private func statLabel(text: String) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .darkGray
        label.text = text
        return label
    }

    private func addConstraints() {
        loadingMask.constrainToSuperviewBounds()
        spinner.centerInSuperview()
        errorLabel.centerInSuperview(insettedBy: UIEdgeInsets(horizontal: 0, vertical: -30))

        profileImage.constrainSize(to: 140)
        view.activateConstraints([
            profileImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            profileImage.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])

        view.activateConstraints([
            nameLabel.topAnchor.constraint(equalTo: profileImage.bottomAnchor, constant: 10),
            nameLabel.centerXAnchor.constraint(equalTo: profileImage.centerXAnchor)
        ])

        view.activateConstraints([
            bioLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10),
            bioLabel.centerXAnchor.constraint(equalTo: nameLabel.centerXAnchor)
        ])

        view.activateConstraints([
            stack.topAnchor.constraint(equalTo: bioLabel.bottomAnchor, constant: 10),
            stack.centerXAnchor.constraint(equalTo: bioLabel.centerXAnchor)
        ])
    }

    private func setupController() {
        title = String(format: "userProfile.title".localized, viewModel.user.login)
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "common.back".localized,
            style: .plain,
            target: self,
            action: #selector(didTapBack)
        )
    }

    private func update(details: UserDetails) {
        self.errorLabel.isHidden = true
        nameLabel.text = details.name
        bioLabel.text = details.bio
        if let email = details.email {
            let text = String(format: "userProfile.email".localized, email)
            stack.addArrangedSubview(statLabel(text: text))
        }
        if let company = details.company {
            let text = String(format: "userProfile.company".localized, company)
            stack.addArrangedSubview(statLabel(text: text))
        }
        if let location = details.location {
            let text = String(format: "userProfile.location".localized, location)
            stack.addArrangedSubview(statLabel(text: text))
        }
        let reposText = String(format: "userProfile.publicRepos".localized, details.publicRepos)
        let gistsText = String(format: "userProfile.publicGists".localized, details.publicGists)
        let followersText = String(format: "userProfile.followers".localized, details.followers)
        let followingText = String(format: "userProfile.following".localized, details.following)
        stack.addArrangedSubview(statLabel(text: reposText))
        stack.addArrangedSubview(statLabel(text: gistsText))
        stack.addArrangedSubview(statLabel(text: followersText))
        stack.addArrangedSubview(statLabel(text: followingText))
    }

    // MARK: Internal methods

    @objc func didTapBack() {
        viewModel.didTapBack()
    }

    func bind() {
        viewModel.loading
            .drive(spinner.rx.isAnimating)
            .disposed(by: disposeBag)

        viewModel.loading
            .inverted()
            .drive(loadingMask.rx.isHidden)
            .disposed(by: disposeBag)

        viewModel.fetchImage()
            .drive(profileImage.rx.image)
            .disposed(by: disposeBag)

        let fetchObservable = viewModel.fetch().observeOn(MainScheduler())
        fetchObservable
            .bind(onNext: self.update)
            .disposed(by: disposeBag)

        fetchObservable.subscribe(onError: { _ in
            self.errorLabel.isHidden = false
        }).disposed(by: disposeBag)
    }
}
