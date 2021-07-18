//
//  TouchView.swift
//  TouchesVisualizer
//
//  Created by Alexandre Podlewski on 18/07/2021.
//

import UIKit

class TouchView: UIView {

    // MARK: - Life cycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        if let context = UIGraphicsGetCurrentContext() {
            let strokeWidth: CGFloat = 3
            let radius = min(rect.width, rect.height) / 2 - strokeWidth / 2
            context.addArc(center: rect.center, radius: radius, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: false)
            
            tintColor.setStroke()
            context.setLineWidth(strokeWidth)
            context.strokePath()
        }
    }

    // MARK: - Private

    private func setup() {
        isOpaque = false
    }
}
