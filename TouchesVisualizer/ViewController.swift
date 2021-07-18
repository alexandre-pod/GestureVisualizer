//
//  ViewController.swift
//  TouchesVisualizer
//
//  Created by Alexandre Podlewski on 18/07/2021.
//

import UIKit

class ViewController: UIViewController {

    private enum Constant {
        static let touchFrameSize = CGSize(width: 100, height: 100)
        static let backgroundColor = UIColor.systemBackground
        static let touchesColor = UIColor.label
    }

    private var touchViews: [TouchView] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Constant.backgroundColor

        let myGesture = TouchesVisualizerRecognizer()
        myGesture.addTarget(self, action: #selector(myGestureTarget(_:)))

        view.addGestureRecognizer(myGesture)
    }

    // MARK: - Private

    @objc private func myGestureTarget(_ sender: TouchesVisualizerRecognizer) {
        ensureNumberOfTouchViews(to: sender.touches.count)
        configureTouchViews(with: sender.touches)
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
                let newView = TouchView()
                newView.tintColor = Constant.touchesColor
                view.addSubview(newView)
                newView.frame.size = Constant.touchFrameSize
                touchViews.append(newView)
            }
        }
    }

    private func configureTouchViews(with touches: Set<UITouch>) {
        for (touchView, touch) in zip(touchViews, touches) {
            touchView.frame.center = touch.location(in: self.view)
        }
    }
}
