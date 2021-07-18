//
//  ViewController.swift
//  TouchesVisualizer
//
//  Created by Alexandre Podlewski on 18/07/2021.
//

import UIKit

class ViewController: UIViewController {

    private enum Constant {
        static let backgroundColor = UIColor.systemBackground
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Constant.backgroundColor

        let touchesVisualizer = TouchesVisualizerRecognizer()
        touchesVisualizer.tintColor = .label
        view.addGestureRecognizer(touchesVisualizer)

        let pinchGestureRecognizer = PinchGestureRecognizer()
        pinchGestureRecognizer.tintColor = .label
        view.addGestureRecognizer(pinchGestureRecognizer)
    }
}
