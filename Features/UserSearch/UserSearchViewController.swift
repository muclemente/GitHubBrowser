//
//  UserSearchViewController.swift
//  Features
//
//  Created by Murilo Clemente on 14/10/2020.
//

import Core
import RxCocoa
import RxDataSources
import RxSwift
import UIKit

final class UserSearchViewController: ListViewController {
    // MARK: Private properties
    private let viewModel: UserSearchViewModel
    private let disposeBag = DisposeBag()

    private lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.definesPresentationContext = true
        searchController.searchBar.placeholder = "userSearch.placeholder".localized
        searchController.searchBar.autocapitalizationType = .none
        searchController.searchBar.delegate = self
        return searchController
    }()

    let dataSource = RxTableViewSectionedReloadDataSource<UserListSection> { _, tableView, indexPath, user -> UITableViewCell in
        let cell = UserListCell.dequeueCell(from: tableView, at: indexPath)
        cell.update(user)
        return cell
    }

    init(viewModel: UserSearchViewModel) {
        self.viewModel = viewModel
        super.init()
    }

    // MARK: Internal methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupController()
        bind()
    }

    private func setupController() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.searchController = searchController
        UserListCell.register(for: tableView)
        title = "userSearch.title".localized
        noDataLabel.text = "userSearch.noData".localized
    }

    private func bind() {
        // Debounce makes sure that there's a minimum time for the user to type before sending the request
        // FlatMapLatest disposes any pending requests in case the debounce timer was fired but another request was made after it
        searchController.searchBar.rx
            .text
            .debounce(AppConstants.inputDebounceTimer, scheduler: MainScheduler.instance)
            .filter { $0 != self.viewModel.searchTerm && $0 != nil }
            .flatMapLatest(viewModel.handleSearchControllerTextChange(text:))
            .observeOn(MainScheduler())
            .bind(to: tableView.rx.items(dataSource: self.dataSource))
            .disposed(by: disposeBag)

        viewModel.dataEmpty
            .inverted()
            .drive(noDataLabel.rx.isHidden)
            .disposed(by: disposeBag)

        viewModel
            .loading
            .drive(spinner.rx.isAnimating)
            .disposed(by: disposeBag)

        viewModel
            .loading
            .inverted()
            .drive(loadingMask.rx.isHidden)
            .disposed(by: disposeBag)

        tableView.rx
            .itemSelected
            .map { self.dataSource[$0] }
            .subscribe { self.viewModel.didSelect(user: $0) }
            .disposed(by: disposeBag)
    }
}

extension UserSearchViewController: UISearchBarDelegate {
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.text = viewModel.searchTerm
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = viewModel.searchTerm
    }
}
