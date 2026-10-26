//
//  Cinevo_iOSUITests.swift
//  Cinevo-iOSUITests
//
//  Created by Amjad on 24/10/26.
//

import XCTest

final class Cinevo_iOSUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    @MainActor
    func testExample() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()

        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // XCUIAutomation Documentation
        // https://developer.apple.com/documentation/xcuiautomation
    }

    @MainActor
    func testTabBarSelection() throws {
        let app = XCUIApplication()
        app.launch()

        let home = app.buttons["tab.home"]
        XCTAssertTrue(home.waitForExistence(timeout: 5))
        XCTAssertTrue(home.isSelected)

        for identifier in ["tab.trending", "tab.popular", "tab.search", "tab.favorites", "tab.home"] {
            let tab = app.buttons[identifier]
            tab.tap()
            XCTAssertTrue(tab.isSelected, "\(identifier) should be selected after tapping it")
            XCTAssertEqual(app.buttons.matching(NSPredicate(format: "isSelected == true AND identifier BEGINSWITH 'tab.'")).count, 1)
        }
    }

    @MainActor
    func testLaunchPerformance() throws {
        // This measures how long it takes to launch your application.
        measure(metrics: [XCTApplicationLaunchMetric()]) {
            XCUIApplication().launch()
        }
    }
}
