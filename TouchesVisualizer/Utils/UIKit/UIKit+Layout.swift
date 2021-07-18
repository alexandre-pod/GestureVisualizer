//
//  UIKit+Layout.swift
//  TouchesVisualizer
//
//  Created by Alexandre Podlewski on 18/07/2021.
//

import UIKit

struct Axis: OptionSet {
    public let rawValue: Int

    public init(rawValue: Int) {
        self.rawValue = rawValue
    }

    static var horizontal = Axis(rawValue: 1<<0)
    static var vertical = Axis(rawValue: 1<<1)
    static var both: Axis = [.horizontal, .vertical]
}

extension UIView {

    @discardableResult
    func pinToSuperView(
        edges: UIRectEdge = .all,
        insets: UIEdgeInsets = .zero,
        priority: UILayoutPriority = .required
    ) -> [NSLayoutConstraint] {
        guard let superview = superview else { return [] }
        return pin(to: superview, edges: edges, insets: insets, priority: priority)
    }

    @discardableResult
    func pin(
        to container: AnchorsProvider,
        edges: UIRectEdge = .all,
        insets: UIEdgeInsets = .zero,
        priority: UILayoutPriority = .required
    ) -> [NSLayoutConstraint] {
        translatesAutoresizingMaskIntoConstraints = false
        let constraints = [
            edges.contains(.top) ? topAnchor.constraint(equalTo: container.topAnchor, constant: insets.top) : nil,
            edges.contains(.bottom) ? bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -insets.bottom) : nil,
            edges.contains(.left) ? leftAnchor.constraint(equalTo: container.leftAnchor, constant: insets.left) : nil,
            edges.contains(.right) ? rightAnchor.constraint(equalTo: container.rightAnchor, constant: -insets.right) : nil,
        ]
            .compactMap { $0 }
            .withPriority(priority)
        NSLayoutConstraint.activate(constraints)
        return constraints
    }

    @discardableResult
    func centerInSuperview(
        along axis: Axis = .both,
        priority: UILayoutPriority = .required
    ) -> [NSLayoutConstraint] {
        guard let superview = superview else { return [] }
        return center(in: superview, along: axis, priority: priority)
    }

    @discardableResult
    func center(
        in container: AnchorsProvider,
        along axis: Axis = .both,
        priority: UILayoutPriority = .required
    ) -> [NSLayoutConstraint] {
        translatesAutoresizingMaskIntoConstraints = false
        let constraints = [
            axis.contains(.horizontal) ? centerXAnchor.constraint(equalTo: container.centerXAnchor) : nil,
            axis.contains(.vertical) ?centerYAnchor.constraint(equalTo: container.centerYAnchor) : nil
        ]
            .compactMap { $0 }
            .withPriority(priority)
        NSLayoutConstraint.activate(constraints)
        return constraints
    }

    @discardableResult
    func constraintInSuperView(
        edges: UIRectEdge = .all,
        insets: UIEdgeInsets = .zero,
        priority: UILayoutPriority = .required
    ) -> [NSLayoutConstraint] {
        guard let superview = superview else { return [] }
        return constraint(to: superview, edges: edges, insets: insets, priority: priority)
    }

    @discardableResult
    func constraint(
        to container: AnchorsProvider,
        edges: UIRectEdge = .all,
        insets: UIEdgeInsets = .zero,
        priority: UILayoutPriority = .required
    ) -> [NSLayoutConstraint] {
        translatesAutoresizingMaskIntoConstraints = false
        let constraints = [
            edges.contains(.top)
            ? topAnchor.constraint(greaterThanOrEqualTo: container.topAnchor, constant: insets.top)
            : nil,
            edges.contains(.bottom)
            ? bottomAnchor.constraint(lessThanOrEqualTo: container.bottomAnchor, constant: -insets.bottom)
            : nil,
            edges.contains(.left)
            ? leftAnchor.constraint(greaterThanOrEqualTo: container.leftAnchor, constant: insets.left)
            : nil,
            edges.contains(.right)
            ? rightAnchor.constraint(lessThanOrEqualTo: container.rightAnchor, constant: -insets.right)
            : nil,
        ]
            .compactMap { $0 }
            .withPriority(priority)
        NSLayoutConstraint.activate(constraints)
        return constraints
    }
}

extension NSLayoutConstraint {
    func withPriority(_ priority: UILayoutPriority) -> NSLayoutConstraint {
        self.priority = priority
        return self
    }
}

extension Collection where Element == NSLayoutConstraint {
    func withPriority(_ priority: UILayoutPriority) -> [NSLayoutConstraint] {
        return map { $0.withPriority(priority) }
    }
}

protocol AnchorsProvider {
    var bottomAnchor: NSLayoutYAxisAnchor { get }
    var centerXAnchor: NSLayoutXAxisAnchor { get }
    var centerYAnchor: NSLayoutYAxisAnchor { get }
    var heightAnchor: NSLayoutDimension { get }
    var leadingAnchor: NSLayoutXAxisAnchor { get }
    var leftAnchor: NSLayoutXAxisAnchor { get }
    var rightAnchor: NSLayoutXAxisAnchor { get }
    var topAnchor: NSLayoutYAxisAnchor { get }
    var trailingAnchor: NSLayoutXAxisAnchor { get }
    var widthAnchor: NSLayoutDimension { get }
}

extension UIView: AnchorsProvider {}
extension UILayoutGuide: AnchorsProvider {}
