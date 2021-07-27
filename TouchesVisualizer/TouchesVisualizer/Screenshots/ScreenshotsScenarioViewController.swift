//
//  ScreenshotsScenarioViewController.swift
//  ScreenshotsScenarioViewController
//
//  Created by Alexandre Podlewski on 27/07/2021.
//

#if DEBUG
import UIKit

struct ScreenshotScenario {

    private let viewCreation: () -> UIView

    init(viewCreation: @escaping () -> UIView) {
        self.viewCreation = viewCreation
    }

    func createView() -> UIView {
        viewCreation()
    }
}

class ScreenshotsScenarioViewController: UIViewController {

    private let scenario: ScreenshotScenario

    init(_ scenario: ScreenshotScenario) {
        self.scenario = scenario
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = scenario.createView()
    }
}
#endif
