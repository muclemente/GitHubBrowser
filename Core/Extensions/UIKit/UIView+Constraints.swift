//
//  UIView+Constraints.swift
//  Core
//
//  Created by Murilo Clemente on 14/10/2020.
//

import UIKit

public extension UIView {
    func constrainToSuperviewBounds(insettedBy insets: UIEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)) {
        guard let superview = superview else {
            fatalError("Constrain to superview bounds, but no superview?")
        }

        activateConstraints([
            topAnchor.constraint(equalTo: superview.topAnchor, constant: insets.top),
            leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: insets.left),
            trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: insets.right),
            bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: insets.bottom)
        ])
    }

    func constrainToSafeAndReadableGuides(insettedBy insets: UIEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)) {
        guard let superview = superview else {
            fatalError("Constrain to safe and readable guides, but no superview?")
        }

        activateConstraints([
            topAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.topAnchor, constant: insets.top),
            leadingAnchor.constraint(equalTo: superview.readableContentGuide.leadingAnchor, constant: insets.left),
            trailingAnchor.constraint(equalTo: superview.readableContentGuide.trailingAnchor, constant: insets.right),
            bottomAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.bottomAnchor, constant: insets.bottom)
        ])
    }

    func centerInSuperview(insettedBy insets: UIEdgeInsets = UIEdgeInsets(horizontal: 0, vertical: 0)) {
        guard let superview = superview else {
            fatalError("Center in superview, but no superview?")
        }

        activateConstraints([
            centerXAnchor.constraint(equalTo: superview.centerXAnchor, constant: insets.left),
            centerYAnchor.constraint(equalTo: superview.centerYAnchor, constant: insets.top)
        ])
    }

    func constrainSize(to dimension: CGFloat) {
        activateConstraints([
            widthAnchor.constraint(equalToConstant: dimension),
            heightAnchor.constraint(equalToConstant: dimension)
        ])
    }

    func activateConstraints(_ constraints: [NSLayoutConstraint]) {
        NSLayoutConstraint.activate(constraints)
    }
}
