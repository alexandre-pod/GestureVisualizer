//
//  FastlaneSnapshots.swift
//  FastlaneSnapshots
//
//  Created by Alexandre Podlewski on 26/07/2021.
//

import XCTest

class FastlaneSnapshots: XCTestCase {

    func testScreenshots() throws {
        takeScreenshot(scenario: "touches", snapshotName: "0Touches")
        takeScreenshot(scenario: "pinch", snapshotName: "1Pinch")
        takeScreenshot(scenario: "rotation", snapshotName: "2Rotation")
        takeScreenshot(scenario: "pinchAndRotation", snapshotName: "3PinchAndRotation")
    }

    // MARK: - Private

    private func takeScreenshot(scenario: String, snapshotName: String) {
        let app = XCUIApplication()
        setupSnapshot(app)
        app.launchEnvironment["screenshot"] = scenario
        app.launch()
        snapshot(snapshotName)
    }
}
