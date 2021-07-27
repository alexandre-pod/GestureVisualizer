//
//  ScreenshotScenario+Environment.swift
//  ScreenshotScenario+Environment
//
//  Created by Alexandre Podlewski on 27/07/2021.
//

#if DEBUG
import Foundation

extension ScreenshotScenario {
    init?(fromEnvironment environmentScenario: String) {
        switch environmentScenario {
        case "touches":
            self = .touchesView
        case "pinch":
            self = .pinchView
        case "rotation":
            self = .rotationView
        case "pinchAndRotation":
            self = .pinchAndRotationView
        default:
            return nil
        }
    }
}
#endif
