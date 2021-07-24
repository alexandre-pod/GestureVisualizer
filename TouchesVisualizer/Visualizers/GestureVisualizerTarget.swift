//
//  GestureVisualizerTarget.swift
//  TouchesVisualizer
//
//  Created by Alexandre Podlewski on 25/07/2021.
//

import CoreGraphics

protocol VisualizerSharingTarget {
    var gestureVisualizerTarget: GestureVisualizerTarget { get }
}

class GestureVisualizerTarget {
    var center: CGPoint
    var initialRadius: CGFloat
    var initialRotation: CGFloat
    var currentScaleFactor: CGFloat?
    var currentRotationFactor: CGFloat?

    init(center: CGPoint = .zero, initialRadius: CGFloat = 10, initialRotation: CGFloat = 0) {
        self.center = center
        self.initialRadius = initialRadius
        self.initialRotation = initialRotation
    }
}

extension GestureVisualizerTarget {
    var currentRadius: CGFloat {
        return initialRadius * (currentScaleFactor ?? 1)
    }
    var currentRotation: CGFloat {
        return initialRotation * (currentRotationFactor ?? 0)
    }
}
