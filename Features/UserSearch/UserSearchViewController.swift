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

final class UserSearchViewController: UserListViewController {
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

    init(viewModel: UserSearchViewModel) {
        self.viewModel = viewModel
        super.init(viewModel: viewModel)
    }

    // MARK: Internal methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupController()
        addSubviews()
        addConstraints()
        setupObservers()
        title = "userSearch.title".localized
    }

    private func setupController() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.searchController = searchController
    }

    private func addSubviews() {
    }

    private func addConstraints() {
    }

    private func setupObservers() {
        let searchUserObservable =
            searchController.searchBar.rx
            .text
            .debounce(AppConstants.inputDebounceTimer, scheduler: MainScheduler.instance)
            .flatMap(viewModel.handleSearchControllerTextChange(text:))

        searchUserObservable
            .observeOn(MainScheduler.instance).subscribe(viewModel.handleFetchUserEvent)
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
