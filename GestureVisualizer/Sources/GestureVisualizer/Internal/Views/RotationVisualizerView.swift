//
//  RotationVisualizerView.swift
//
//
//  Created by Alexandre Podlewski on 25/07/2021.
//

import UIKit

class RotationVisualizerView: UIView {

    struct Configuration {
        let active: Bool
        let center: CGPoint
        let initialRadius: CGFloat
        let rotation: CGFloat

        static let empty = Configuration(active: false, center: .zero, initialRadius: 100.0, rotation: 0.0)
    }

    private var configuration: Configuration = .empty {
        didSet { setNeedsDisplay() }
    }

    private let angleNumberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 1
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

    // MARK: - RotationVisualizerView

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

        let stokeWidth: CGFloat = 16
        context.addArc(
            center: configuration.center,
            radius: configuration.initialRadius,
            startAngle: 0,
            endAngle: 2 * CGFloat.pi,
            clockwise: false
        )
        tintColor.withAlphaComponent(0.4).setStroke()
        context.setLineWidth(stokeWidth)
        context.setLineCap(.round)
        context.strokePath()

        context.addArc(
            center: configuration.center,
            radius: configuration.initialRadius,
            startAngle: -CGFloat.pi / 2,
            endAngle: -CGFloat.pi / 2 + configuration.rotation,
            clockwise: configuration.rotation < 0
        )
        tintColor.setStroke()
        context.setLineWidth(stokeWidth * 0.7)
        context.setLineCap(.round)
        context.strokePath()


        let angle = Measurement<UnitAngle>(value: configuration.rotation, unit: .radians)

        let angleNumber = angle.converted(to: .degrees).value
        context.drawText(
            "\(angleNumberFormatter.string(for: angleNumber) ?? "")°",
            centeredOn: configuration.center + CGPoint(x: 0, y: -configuration.initialRadius - 20),
            color: tintColor
        )
    }
}

