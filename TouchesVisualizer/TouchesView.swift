//
//  TouchesView.swift
//  TouchesVisualizer
//
//  Created by Alexandre Podlewski on 18/07/2021.
//

import UIKit

struct TouchesViewConfiguration {
    let touches: [CGPoint]
    let lines: [Line]

    struct Line {
        let start: CGPoint
        let end: CGPoint
    }

    static let empty = TouchesViewConfiguration(touches: [], lines: [])
}

class TouchesView: UIView {

    private var configuration: TouchesViewConfiguration = .empty {
        didSet { setNeedsDisplay() }
    }

    private var touchRadius: CGFloat = 50

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
            tintColor.setStroke()
            // Draw lines need to be called before the touches to remove the lines from the circles
            drawLines(in: context)
            drawTouches(in: context)
        }
    }

    func configure(with viewModel: TouchesViewConfiguration) {
        configuration = viewModel
    }

    // MARK: - Private

    private func setup() {
        isOpaque = false
        isUserInteractionEnabled = false
    }

    private func drawLines(in context: CGContext) {
        context.setLineWidth(1)
        for line in configuration.lines {
            context.move(to: line.start)
            context.addLine(to: line.end)
        }
        context.strokePath()
    }

    private func drawTouches(in context: CGContext) {
        let touchStrokeWidth: CGFloat = 3

        context.setLineWidth(touchStrokeWidth)
        let touchRadius = self.touchRadius - touchStrokeWidth / 2

        for touchPosition in configuration.touches {
            let path = UIBezierPath()
            path.addArc(
                withCenter: touchPosition,
                radius: touchRadius,
                startAngle: 0,
                endAngle: 2 * CGFloat.pi,
                clockwise: false
            )
            path.lineWidth = touchStrokeWidth
            // This fill clears the line inside the touch circle
            path.fill(with: .copy, alpha: 0)
            path.stroke()
        }
    }
}
