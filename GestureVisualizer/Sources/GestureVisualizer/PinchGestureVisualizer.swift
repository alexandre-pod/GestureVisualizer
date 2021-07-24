//
//  PinchGestureVisualizer.swift
//  TouchesVisualizer
//
//  Created by Alexandre Podlewski on 18/07/2021.
//

import UIKit

public class PinchGestureVisualizer: UIPinchGestureRecognizer, UIGestureRecognizerDelegate {

    private let visualizerView = PinchVisualizerView()
    var visualizerTarget = GestureVisualizerTarget()
    private var isVisualizerTargetShared = false

    public var tintColor: UIColor {
        get { visualizerView.tintColor }
        set { visualizerView.tintColor = newValue }
    }

    // MARK: - Life cycle

    override init(target: Any?, action: Selector?) {
        super.init(target: target, action: action)
        self.delegate = self
        addTarget(self, action: #selector(pinchGestureChanged(_:)))
        cancelsTouchesInView = false
        delaysTouchesBegan = false
        delaysTouchesEnded = false
    }

    // MARK: - UIGestureRecognizerDelegate

    public func gestureRecognizer(
        _ gestureRecognizer: UIGestureRecognizer,
        shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer
    ) -> Bool {
        if let visualizerSharingTarget = otherGestureRecognizer as? VisualizerSharingTarget {
            visualizerTarget = visualizerSharingTarget.gestureVisualizerTarget
            isVisualizerTargetShared = true
        }
        return true
    }

    // MARK: - Private

    @objc private func pinchGestureChanged(_ sender: UIPinchGestureRecognizer) {
        installVisualizerViewIfNeeded()
        if
            isVisualizerTargetShared,
            state == .cancelled || state == .ended || state == .failed
        {
            visualizerTarget = GestureVisualizerTarget()
            isVisualizerTargetShared = false
        }
        if
            !isVisualizerTargetShared,
            state == .began
        {
            let center = touchesCenter()
            visualizerTarget.center = center
            visualizerTarget.initialRadius = initialFirstPointRadius(to: center)
        }
        visualizerTarget.currentScaleFactor = scale
        visualizerView.configure(
            with: PinchVisualizerView.Configuration(
                active: state == .began || state == .changed,
                center: visualizerTarget.center,
                initialRadius: visualizerTarget.initialRadius,
                scale: visualizerTarget.currentScaleFactor ?? scale
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

extension PinchGestureVisualizer: VisualizerSharingTarget {

    // MARK: - VisualizerSharingTarget

    var gestureVisualizerTarget: GestureVisualizerTarget { visualizerTarget }
}

private class PinchVisualizerView: UIView {

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
