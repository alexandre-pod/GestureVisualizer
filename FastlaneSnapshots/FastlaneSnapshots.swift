//
//  FastlaneSnapshots.swift
//  FastlaneSnapshots
//
//  Created by Alexandre Podlewski on 26/07/2021.
//

import XCTest

class FastlaneSnapshots: XCTestCase {

    func testExample() throws {
        let app = XCUIApplication()
        setupSnapshot(app)
        app.launch()
    }
}
