//
//  TouchesVisualizerRecognizer.swift
//  TouchesVisualizer
//
//  Created by Alexandre Podlewski on 18/07/2021.
//

import UIKit

class TouchesVisualizerRecognizer: UIGestureRecognizer {

    private(set) var touches: Set<UITouch> = []

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesBegan(touches, with: event)
        let isFirstTouch = touches.isEmpty
        touches.forEach {
            self.touches.insert($0)
        }
        state = isFirstTouch ? .began : .changed
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesMoved(touches, with: event)
        touches.forEach { self.touches.insert($0) }
        state = .changed
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesCancelled(touches, with: event)
        let allCancelled = self.touches.count == touches.count
        touches.forEach { self.touches.remove($0) }
        state = allCancelled ? .cancelled : .changed
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesEnded(touches, with: event)
        let allTouchesRemoved = self.touches.count == touches.count
        touches.forEach { self.touches.remove($0) }
        state = allTouchesRemoved ? .ended : .changed
    }
}
