//
//  RotationGestureVisualizer.swift
//  TouchesVisualizer
//
//  Created by Alexandre Podlewski on 18/07/2021.
//

import UIKit

class RotationGestureVisualizer: UIRotationGestureRecognizer, UIGestureRecognizerDelegate {
    private let visualizerView = PinchVisualizerView()
    private var initialCenter: CGPoint?
    private var initialRadius: CGFloat?

    var tintColor: UIColor {
        get { visualizerView.tintColor }
        set { visualizerView.tintColor = newValue }
    }

    // MARK: - Life cycle

    override init(target: Any?, action: Selector?) {
        super.init(target: target, action: action)
        self.delegate = self
        addTarget(self, action: #selector(rotationGestureChanged(_:)))
        cancelsTouchesInView = false
        delaysTouchesBegan = false
        delaysTouchesEnded = false
    }

    // MARK: - UIGestureRecognizerDelegate

    func gestureRecognizer(
        _ gestureRecognizer: UIGestureRecognizer,
        shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer
    ) -> Bool {
        return true
    }

    // MARK: - Private

    @objc private func rotationGestureChanged(_ sender: UIPinchGestureRecognizer) {
        installVisualizerViewIfNeeded()
        if state == .began {
            let center = touchesCenter()
            initialCenter = center
            initialRadius = initialFirstPointRadius(to: center)
        }
        print(state == .ended)
        visualizerView.configure(
            with: PinchVisualizerView.Configuration(
                active: state == .began || state == .changed,
                center: initialCenter ?? .zero,
                initialRadius: initialRadius ?? 100,
                rotation: rotation
            )
        )
    }

    private func installVisualizerViewIfNeeded() {
        if visualizerView.superview != view {
            if let view = view {
                view.addSubview(visualizerView)
                visualizerView.pinToSuperView()
            } else {
                visualizerView.removeFromSuperview()
            }
        }
    }

    private func touchesCenter() -> CGPoint {
        return (0..<numberOfTouches)
            .map { location(ofTouch: $0, in: visualizerView) }
            .reduce(.zero, +) / CGFloat(numberOfTouches)
    }

    private func initialFirstPointRadius(to center: CGPoint) -> CGFloat {
        guard numberOfTouches >= 1 else { return 100 }

        let firstPointLocation = location(ofTouch: 0, in: visualizerView)
        let dx = center.x - firstPointLocation.x
        let dy = center.y - firstPointLocation.y
        return sqrt(dx * dx + dy * dy)
    }
}

private class PinchVisualizerView: UIView {

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
