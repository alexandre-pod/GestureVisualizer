//
//  RotationGestureVisualizer.swift
//  TouchesVisualizer
//
//  Created by Alexandre Podlewski on 18/07/2021.
//

import UIKit

public class RotationGestureVisualizer: UIRotationGestureRecognizer {

    public var tintColor: UIColor {
        get { visualizerView.tintColor }
        set { visualizerView.tintColor = newValue }
    }

    var visualizerTarget = GestureVisualizerTarget()

    private let visualizerView = RotationVisualizerView()
    private var isVisualizerTargetShared = false

    // MARK: - Life cycle

    override init(target: Any?, action: Selector?) {
        super.init(target: target, action: action)
        self.delegate = self
        addTarget(self, action: #selector(rotationGestureChanged(_:)))
        cancelsTouchesInView = false
        delaysTouchesBegan = false
        delaysTouchesEnded = false
    }

    // MARK: - Private

    @objc private func rotationGestureChanged(_ sender: UIPinchGestureRecognizer) {
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
        visualizerTarget.currentRotationFactor = rotation
        visualizerView.configure(
            with: RotationVisualizerView.Configuration(
                active: state == .began || state == .changed,
                center: visualizerTarget.center,
                initialRadius: visualizerTarget.currentRadius + 16,
                rotation: visualizerTarget.currentRotationFactor ?? 0
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

extension RotationGestureVisualizer: UIGestureRecognizerDelegate {

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
}

extension RotationGestureVisualizer: VisualizerSharingTarget {

    // MARK: - VisualizerSharingTarget

    var gestureVisualizerTarget: GestureVisualizerTarget {
        self.visualizerTarget
    }
}
