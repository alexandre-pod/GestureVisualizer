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

    private func drawTouches(in context: CGContext) {
        for (index, touchPosition) in configuration.touches.enumerated() {
            drawTouch(touchPosition, in: context)
            drawTouchDetails(touchPosition, index: index, in: context)
        }
    }

    private func drawTouch(_ touchPosition: CGPoint, in context: CGContext) {
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
        // This fill clears the line inside the touch circle
        path.fill(with: .copy, alpha: 0)
        path.stroke()
    }

    private func drawTouchDetails(_ touchPosition: CGPoint, index: Int, in context: CGContext) {
        drawText(
            "#\(index)",
            centeredOn: touchPosition + CGPoint(x: 0, y: -touchRadius * 1.5),
            in: context
        )
        drawText(
            positionFormatter.string(from: touchPosition.x as NSNumber) ?? "",
            centeredOn: touchPosition + CGPoint(x: -touchRadius * 1.5, y: 0),
            in: context
        )
        drawText(
            positionFormatter.string(from: touchPosition.y as NSNumber) ?? "",
            centeredOn: touchPosition + CGPoint(x: 0, y: touchRadius * 1.5),
            rotationAngle: CGFloat.pi / 2,
            in: context
        )
    }

    private func drawText(
        _ text: String,
        centeredOn center: CGPoint,
        rotationAngle angle: CGFloat = 0,
        in context: CGContext
    ) {
        context.saveGState()
        let indexText = NSAttributedString(
            string: text,
            attributes: [NSAttributedString.Key.foregroundColor: tintColor as Any]
        )
        let indexTextSize = indexText.size()
        context.translateBy(x: center.x, y: center.y)
        context.concatenate(CGAffineTransform(rotationAngle: angle))
        indexText.draw(at: .zero - indexTextSize / 2)

        context.restoreGState()
    }
}
