//
//  SwiftCombineCalculatorUITestsLaunchTests.swift
//  SwiftCombineCalculatorUITests
//
//  Created by William.Weng on 2024/2/16.
//

import XCTest

final class SwiftCombineCalculatorUITestsLaunchTests: XCTestCase {

    override class var runsForEachTargetApplicationUIConfiguration: Bool {
        true
    }

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testLaunch() throws {
        let app = XCUIApplication()
        app.launch()

        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = "Launch Screen"
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}
