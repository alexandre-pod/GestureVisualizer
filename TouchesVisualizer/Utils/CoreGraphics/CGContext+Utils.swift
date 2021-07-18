//
//  CGContext+Utils.swift
//  TouchesVisualizer
//
//  Created by Alexandre Podlewski on 18/07/2021.
//

import UIKit

extension CGContext {
    func drawText(
        _ text: String,
        centeredOn center: CGPoint,
        rotationAngle angle: CGFloat = 0,
        color: UIColor
    ) {
        saveGState()
        let indexText = NSAttributedString(
            string: text,
            attributes: [NSAttributedString.Key.foregroundColor: color]
        )
        let indexTextSize = indexText.size()
        translateBy(x: center.x, y: center.y)
        concatenate(CGAffineTransform(rotationAngle: angle))
        indexText.draw(at: .zero - indexTextSize / 2)

        restoreGState()
    }
}
