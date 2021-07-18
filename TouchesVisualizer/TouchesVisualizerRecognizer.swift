//
//  TouchesVisualizerRecognizer.swift
//  TouchesVisualizer
//
//  Created by Alexandre Podlewski on 18/07/2021.
//

import UIKit

class TouchesVisualizerRecognizer: UIGestureRecognizer {

    private(set) var touches: Set<UITouch> = []

    private var touchViews: [TouchView] = []

    private let touchFrameSize = CGSize(width: 100, height: 100)
    private let touchesColor = UIColor.label

    // MARK: - UIGestureRecognizer

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesBegan(touches, with: event)
        let isFirstTouch = touches.isEmpty
        touches.forEach {
            self.touches.insert($0)
        }
        state = isFirstTouch ? .began : .changed
        updateTouchViews()
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesMoved(touches, with: event)
        touches.forEach { self.touches.insert($0) }
        state = .changed
        updateTouchViews()
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesCancelled(touches, with: event)
        let allCancelled = self.touches.count == touches.count
        touches.forEach { self.touches.remove($0) }
        state = allCancelled ? .cancelled : .changed
        updateTouchViews()
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesEnded(touches, with: event)
        let allTouchesRemoved = self.touches.count == touches.count
        touches.forEach { self.touches.remove($0) }
        state = allTouchesRemoved ? .ended : .changed
        updateTouchViews()
    }

    // MARK: - Private

    private func updateTouchViews() {
        ensureNumberOfTouchViews(to: touches.count)
        configureTouchViews(with: touches)
    }

    private func ensureNumberOfTouchViews(to number: Int) {
        assert(number >= 0)
        guard touchViews.count != number else { return }
        if touchViews.count > number {
            for index in number..<touchViews.count {
                touchViews[index].removeFromSuperview()
            }
            touchViews.removeLast(touchViews.count - number)
        } else {
            let missingViews = number - touchViews.count
            for _ in (0..<missingViews) {
                let touchView = TouchView()
                touchView.tintColor = touchesColor
                view?.addSubview(touchView)
                touchView.frame.size = touchFrameSize
                touchViews.append(touchView)
            }
        }
    }

    private func configureTouchViews(with touches: Set<UITouch>) {
        guard let view = view else { return }
        for (touchView, touch) in zip(touchViews, touches) {
            if touchView.superview != view {
                touchView.removeFromSuperview()
                view.addSubview(touchView)
            }
            touchView.frame.center = touch.location(in: view)
        }
    }
}
