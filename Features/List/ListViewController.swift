//
//  ListViewController.swift
//  Features
//
//  Created by Murilo Clemente on 14/10/2020.
//

import Core
import RxCocoa
import RxDataSources
import RxSwift
import UIKit

class ListViewController: UIViewController {
    // MARK: Private properties
    private let disposeBag = DisposeBag()

    // MARK: public methods
    init() {
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("Tried to initialize UserSearchViewController from a xib")
    }

    internal lazy var spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .gray)
        spinner.hidesWhenStopped = true
        spinner.translatesAutoresizingMaskIntoConstraints = false
        return spinner
    }()

    internal lazy var loadingMask: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .darkGray
        view.alpha = 0.7
        view.isHidden = true
        return view
    }()

    internal lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.estimatedRowHeight = 40
        tableView.tableFooterView = UIView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = UITableView.automaticDimension
        return tableView
    }()

    internal lazy var noDataLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isHidden = true
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .darkGray
        return label
    }()

    // MARK: Internal methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupController()
        addSubviews()
        addConstraints()
    }

    // MARK: Internal methods
    private func setupController() {
    }

    private func addSubviews() {
        view.addSubview(tableView)
        view.addSubview(loadingMask)
        view.addSubview(spinner)
        view.addSubview(noDataLabel)
    }

    private func addConstraints() {
        spinner.centerInSuperview()
        loadingMask.constrainToSuperviewBounds()
        tableView.constrainToSuperviewBounds()
        noDataLabel.centerInSuperview(insettedBy: UIEdgeInsets(horizontal: 0, vertical: -30))
    }
}
