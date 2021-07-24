//
//  ViewController.swift
//  TouchesVisualizer
//
//  Created by Alexandre Podlewski on 18/07/2021.
//

import UIKit
import GestureVisualizer

class ViewController: UIViewController {

    private enum Constant {
        static let backgroundColor = UIColor.systemBackground
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Constant.backgroundColor

        let touchesVisualizer = TouchesVisualizer()
        touchesVisualizer.tintColor = .label
        view.addGestureRecognizer(touchesVisualizer)

        let pinchGestureVisualizer = PinchGestureVisualizer()
        pinchGestureVisualizer.tintColor = .label
        view.addGestureRecognizer(pinchGestureVisualizer)

        let rotationGestureVisualizer = RotationGestureVisualizer()
        rotationGestureVisualizer.tintColor = .label
        view.addGestureRecognizer(rotationGestureVisualizer)
    }
}
