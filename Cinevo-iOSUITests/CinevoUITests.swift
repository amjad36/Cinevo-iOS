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

        let tabBar = app.tabBars.firstMatch
        let home = tabBar.buttons["Home"]
        XCTAssertTrue(home.waitForExistence(timeout: 5))
        XCTAssertTrue(home.isSelected)

        for title in ["Trending", "Popular", "Search", "Favorites", "Home"] {
            let tab = tabBar.buttons[title]
            tab.tap()
            XCTAssertTrue(tab.isSelected, "\(title) should be selected after tapping it")
            XCTAssertEqual(tabBar.buttons.matching(NSPredicate(format: "isSelected == true")).count, 1)
            XCTAssertTrue(app.navigationBars[title].waitForExistence(timeout: 2), "\(title) screen should be shown")
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
