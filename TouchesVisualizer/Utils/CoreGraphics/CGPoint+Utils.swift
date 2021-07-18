//
//  CGPoint+Utils.swift
//  TouchesVisualizer
//
//  Created by Alexandre Podlewski on 18/07/2021.
//

import CoreGraphics

extension CGPoint {
    static func +(lhs: CGPoint, rhs: CGSize) -> CGPoint {
        return CGPoint(
            x: lhs.x + rhs.width,
            y: lhs.y + rhs.height
        )
    }

    static func -(lhs: CGPoint, rhs: CGSize) -> CGPoint {
        return CGPoint(
            x: lhs.x - rhs.width,
            y: lhs.y - rhs.height
        )
    }
}
