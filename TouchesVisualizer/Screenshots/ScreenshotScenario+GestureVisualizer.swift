//
//  ScreenshotScenario+GestureVisualizer.swift
//  ScreenshotScenario+GestureVisualizer
//
//  Created by Alexandre Podlewski on 27/07/2021.
//

#if DEBUG
import UIKit
@testable import GestureVisualizer

extension ScreenshotScenario {

    private static let point1 = CGPoint(x: 99, y: 494)
    private static let point2 = CGPoint(x: 165, y: 289)
    private static let point3 = CGPoint(x: 306, y: 258)
    private static let center = CGPoint(x: 200, y: 400)
    private static let initialRadius: CGFloat = 100
    private static let scale: CGFloat = 1.42
    private static let rotation: CGFloat = CGFloat.pi / 3

    static let touchesView = ScreenshotScenario {
        let touchesView = TouchesView()

        touchesView.configure(
            with: TouchesViewConfiguration(
                touches: [point1, point2, point3],
                lines: [
                    TouchesViewConfiguration.Line(start: point1, end: point2),
                    TouchesViewConfiguration.Line(start: point2, end: point3)
                ]
            )
        )
        return touchesView
    }.labelTintColor()

    static let pinchView = ScreenshotScenario {
        let pinchView = PinchVisualizerView()
        pinchView.configure(
            with: PinchVisualizerView.Configuration(
                active: true,
                center: center,
                initialRadius: initialRadius,
                scale: scale
            )
        )
        return pinchView
    }.labelTintColor()

    static let rotationView = ScreenshotScenario {
        let rotationView = RotationVisualizerView()
        rotationView.configure(
            with: RotationVisualizerView.Configuration(
                active: true,
                center: center,
                initialRadius: initialRadius,
                rotation: rotation
            )
        )
        return rotationView
    }.labelTintColor()

    static let pinchAndRotationView = ScreenshotScenario {
        let pinchView = PinchVisualizerView()
        let rotationView = RotationVisualizerView()

        let view = UIView()
        view.addSubview(pinchView)
        pinchView.translatesAutoresizingMaskIntoConstraints = false
        pinchView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        pinchView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        pinchView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        pinchView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true

        view.addSubview(rotationView)
        rotationView.translatesAutoresizingMaskIntoConstraints = false
        rotationView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        rotationView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        rotationView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        rotationView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true

        pinchView.configure(
            with: PinchVisualizerView.Configuration(
                active: true,
                center: center,
                initialRadius: initialRadius,
                scale: scale
            )
        )
        rotationView.configure(
            with: RotationVisualizerView.Configuration(
                active: true,
                center: center,
                initialRadius: initialRadius * scale,
                rotation: rotation
            )
        )
        return view
    }.labelTintColor()

    // MARK: - Private

    private func labelTintColor() -> Self {
        ScreenshotScenario {
            let view = self.createView()
            view.tintColor = .label
            return view
        }
    }
}
#endif
