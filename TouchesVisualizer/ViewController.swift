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

    private var touchViews: [TouchView] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Constant.backgroundColor

        view.addGestureRecognizer(TouchesVisualizerRecognizer())
    }
}
