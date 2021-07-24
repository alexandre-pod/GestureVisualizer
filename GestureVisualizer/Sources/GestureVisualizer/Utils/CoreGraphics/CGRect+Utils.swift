//
//  CGRect+Utils.swift
//  TouchesVisualizer
//
//  Created by Alexandre Podlewski on 18/07/2021.
//

import CoreGraphics

extension CGRect {
    var center: CGPoint {
        get { origin + size / 2 }
        set { origin = newValue - size / 2 }
    }
}
