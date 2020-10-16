//
//  ReusableView.swift
//  Core
//
//  Created by Murilo Clemente on 15/10/2020.
//

import UIKit

public protocol ReusableView {}

public extension ReusableView where Self: UITableViewCell {
    static var cellIdentifier: String {
        "\(Self.self)"
    }

    static func register(for tableView: UITableView) {
        tableView.register(self.classForCoder(), forCellReuseIdentifier: cellIdentifier)
    }

    static func dequeueCell(from tableView: UITableView, at indexPath: IndexPath) -> Self {
        if let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? Self {
            return cell
        } else {
            return Self()
        }
    }
}
