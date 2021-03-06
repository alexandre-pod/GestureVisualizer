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

    private let touchRadius: CGFloat = 40
    private let touchStrokeWidth: CGFloat = 4

    private let positionFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 0
        return formatter
    }()

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
            clearBelowTouches(in: context)
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
        context.setLineWidth(1 / UIScreen.main.scale)
        for line in configuration.lines {
            context.move(to: line.start)
            context.addLine(to: line.end)
        }
        context.strokePath()
    }

    private func clearBelowTouches(in context: CGContext) {
        for touchPosition in configuration.touches {
            touchPath(at: touchPosition).fill(with: .copy, alpha: 0)
        }
    }

    private func drawTouches(in context: CGContext) {
        for (index, touchPosition) in configuration.touches.enumerated() {
            touchPath(at: touchPosition).stroke()
            drawTouchDetails(touchPosition, index: index, in: context)
        }
    }

    private func touchPath(at touchPosition: CGPoint) -> UIBezierPath {
        let touchRadius = self.touchRadius - touchStrokeWidth / 2
        let path = UIBezierPath()
        path.addArc(
            withCenter: touchPosition,
            radius: touchRadius,
            startAngle: 0,
            endAngle: 2 * CGFloat.pi,
            clockwise: false
        )
        path.lineWidth = touchStrokeWidth
        return path
    }

    private func drawTouchDetails(_ touchPosition: CGPoint, index: Int, in context: CGContext) {
        context.drawText(
            "#\(index)",
            centeredOn: touchPosition + CGPoint(x: 0, y: -touchRadius * 1.5),
            color: tintColor
        )
        context.drawText(
            positionFormatter.string(from: touchPosition.x as NSNumber) ?? "",
            centeredOn: touchPosition + CGPoint(x: -touchRadius * 1.5, y: 0),
            color: tintColor
        )
        context.drawText(
            positionFormatter.string(from: touchPosition.y as NSNumber) ?? "",
            centeredOn: touchPosition + CGPoint(x: 0, y: touchRadius * 1.5),
            rotationAngle: CGFloat.pi / 2,
            color: tintColor
        )
    }
}
