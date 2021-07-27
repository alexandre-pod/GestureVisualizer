//
//  PinchVisualizerView.swift
//
//
//  Created by Alexandre Podlewski on 25/07/2021.
//

import UIKit

class PinchVisualizerView: UIView {

    struct Configuration {
        let active: Bool
        let center: CGPoint
        let initialRadius: CGFloat
        let scale: CGFloat

        static let empty = Configuration(active: false, center: .zero, initialRadius: 100.0, scale: 1.0)
    }

    private var configuration: Configuration = .empty {
        didSet { setNeedsDisplay() }
    }

    private let scaleNumberFormatter: NumberFormatter = {
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
            drawIndicator(in: context)
        }
    }

    // MARK: - PinchVisualizerView

    func configure(with viewModel: Configuration) {
        configuration = viewModel
    }

    // MARK: - Private

    private func setup() {
        isOpaque = false
        isUserInteractionEnabled = false
    }

    private func drawIndicator(in context: CGContext) {
        guard configuration.active else { return }

        let stokeWidth = 1 / UIScreen.main.scale
        context.addArc(
            center: configuration.center,
            radius: configuration.initialRadius,
            startAngle: 0,
            endAngle: 2 * CGFloat.pi,
            clockwise: false
        )
        tintColor.withAlphaComponent(0.5).setStroke()
        context.setLineWidth(stokeWidth)
        context.strokePath()
        context.addArc(
            center: configuration.center,
            radius: configuration.initialRadius * configuration.scale,
            startAngle: 0,
            endAngle: 2 * CGFloat.pi,
            clockwise: false
        )
        tintColor.setStroke()
        context.setLineWidth(2 * stokeWidth)
        context.strokePath()

        context.move(to: configuration.center + CGPoint(x: -configuration.initialRadius, y: 0))
        context.addLine(to: configuration.center + CGPoint(x: -configuration.initialRadius * configuration.scale, y: 0))

        context.setLineWidth(6)
        context.setLineCap(.round)
        context.strokePath()

        context.drawText(
            "\(scaleNumberFormatter.string(for: configuration.scale * 100) ?? "")%",
            centeredOn: configuration.center + CGPoint(x: -configuration.initialRadius * max(1, configuration.scale) - 24, y: 0),
            color: tintColor
        )
    }
}
