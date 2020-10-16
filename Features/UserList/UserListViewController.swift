//
//  UserListViewController.swift
//  Features
//
//  Created by Murilo Clemente on 14/10/2020.
//

import Core
import RxCocoa
import RxDataSources
import RxSwift
import UIKit

class UserListViewController: UIViewController {
    // MARK: Private properties
    private let viewModel: UserListViewModelable
    private let disposeBag = DisposeBag()

    // MARK: public methods
    init(viewModel: UserListViewModelable) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("Tried to initialize UserSearchViewController from a xib")
    }

    private lazy var spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .gray)
        spinner.hidesWhenStopped = true
        spinner.translatesAutoresizingMaskIntoConstraints = false
        return spinner
    }()

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.estimatedRowHeight = 40
        tableView.tableFooterView = UIView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = UITableView.automaticDimension
        UserListCell.register(for: tableView)
        return tableView
    }()

    // MARK: Internal methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupController()
        addSubviews()
        addConstraints()
        bind()
    }

    // MARK: Internal methods
    private func setupController() {
    }

    private func addSubviews() {
        view.addSubview(tableView)
        view.addSubview(spinner)
    }

    private func addConstraints() {
        spinner.centerInSuperview()
        tableView.constrainToSuperviewBounds()
    }

    let dataSource = RxTableViewSectionedReloadDataSource<UserSection> { _, tableView, indexPath, user -> UITableViewCell in
        let cell = UserListCell.dequeueCell(from: tableView, at: indexPath)
        cell.update(user)
        return cell
    }

    private func bind() {
        viewModel.loading.bind(to: spinner.rx.isAnimating).disposed(by: disposeBag)
        viewModel.usersSection.bind(to: tableView.rx.items(dataSource: self.dataSource)).disposed(by: disposeBag)
    }
}
