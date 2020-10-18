//
//  UserRepositoriesViewController.swift
//  Features
//
//  Created by Murilo Clemente on 17/10/2020.
//

import RxCocoa
import RxDataSources
import RxSwift
import UIKit

class UserRepositoriesViewController: ListViewController {
    // MARK: Private properties
    private let viewModel: UserRepositoriesViewModel
    private let disposeBag = DisposeBag()

    // MARK: public methods
    init(viewModel: UserRepositoriesViewModel) {
        self.viewModel = viewModel
        super.init()
    }

    // MARK: Internal methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupController()
        bind()
    }

    // MARK: Internal methods
    private func setupController() {
        title = String(format: "userRepo.title".localized, viewModel.user.login)
        UserRepositoryCell.register(for: tableView)
        noDataLabel.text = "userRepo.noData".localized

        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "common.back".localized,
            style: .plain,
            target: self,
            action: #selector(didTapBack)
        )

        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(named: "person_icon"),
            style: .plain,
            target: self,
            action: #selector(didTapProfile)
        )
    }

    @objc func didTapBack() {
        viewModel.didTapBack()
    }

    @objc func didTapProfile() {
        viewModel.didTapProfile()
    }

    private func bind() {
        viewModel.loading
            .drive(spinner.rx.isAnimating)
            .disposed(by: disposeBag)

        viewModel.loading
            .inverted()
            .drive(loadingMask.rx.isHidden)
            .disposed(by: disposeBag)

        viewModel.dataEmpty
            .inverted()
            .drive(noDataLabel.rx.isHidden)
            .disposed(by: disposeBag)

        viewModel.fetchRepositories()
            .drive(tableView.rx.items(cellIdentifier: UserRepositoryCell.cellIdentifier, cellType: UserRepositoryCell.self)) { _, item, cell in
                cell.update(item)
            }.disposed(by: disposeBag)
    }
}
