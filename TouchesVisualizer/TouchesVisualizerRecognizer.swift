//
//  TouchesVisualizerRecognizer.swift
//  TouchesVisualizer
//
//  Created by Alexandre Podlewski on 18/07/2021.
//

import UIKit

class TouchesVisualizerRecognizer: UIGestureRecognizer {

    var tintColor: UIColor {
        get { touchesView.tintColor }
        set { touchesView.tintColor = newValue }
    }

    private var touches: Set<UITouch> = []
    private var touchesView = TouchesView()

    private let touchFrameSize = CGSize(width: 100, height: 100)
    private let touchesColor = UIColor.label

    // MARK: - UIGestureRecognizer

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesBegan(touches, with: event)
        let isFirstTouch = touches.isEmpty
        touches.forEach { self.touches.insert($0) }
        state = isFirstTouch ? .began : .changed
        updateTouchesView()
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesMoved(touches, with: event)
        touches.forEach { self.touches.insert($0) }
        state = .changed
        updateTouchesView()
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesCancelled(touches, with: event)
        let allCancelled = self.touches.count == touches.count
        touches.forEach { self.touches.remove($0) }
        state = allCancelled ? .cancelled : .changed
        updateTouchesView()
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesEnded(touches, with: event)
        let allTouchesRemoved = self.touches.count == touches.count
        touches.forEach { self.touches.remove($0) }
        state = allTouchesRemoved ? .ended : .changed
        updateTouchesView()
    }

    // MARK: - Private

    private func updateTouchesView() {
        installTouchesViewIfNeeded()
        let points = touches.map { $0.location(in: touchesView) }
        let config = TouchesViewConfiguration(
            touches: points,
            lines: lines(for: points)
        )
        touchesView.configure(with: config)
    }

    private func installTouchesViewIfNeeded() {
        if touchesView.superview != self.view {
            if let view = self.view {
                view.addSubview(touchesView)
                touchesView.pinToSuperView()
            } else {
                touchesView.removeFromSuperview()
            }
        }
    }

    private func lines(for points: [CGPoint]) -> [TouchesViewConfiguration.Line] {
        PrimsAlgorithm(nodes: points)
            .execute()
            .map { TouchesViewConfiguration.Line(start: $0.node1, end: $0.node2) }
    }
}

extension CGPoint: Distancable, Hashable {
    static func distance(from point1: CGPoint, to point2: CGPoint) -> CGFloat {
        let dx = point1.x - point2.x
        let dy = point1.y - point2.y
        return dx * dx + dy * dy
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(x)
        hasher.combine(y)
    }
}
