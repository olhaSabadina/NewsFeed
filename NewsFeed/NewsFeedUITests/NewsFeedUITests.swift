//
//  NewsFeedUITests.swift
//  NewsFeedUITests
//
//  Created by Olga Sabadina on 12.12.2023.
//

import XCTest

@testable import NewsFeed

final class NewsFeedUITests: XCTestCase {
    
    func testWorkTabBar() {
        let app = XCUIApplication()
        app.launch()
        
        let loadedTabBar = app.navigationBars["Time Line"].staticTexts["Time Line"]
        XCTAssert(loadedTabBar.exists)
        let expectation = XCTNSPredicateExpectation(predicate: NSPredicate(format: "exists == true"), object: loadedTabBar)
        wait(for: [expectation], timeout: 10)
        
        let tabBar = XCUIApplication().tabBars["Tab Bar"]
        guard tabBar.exists else {
            XCTFail("Warning Error tabBar not exists")
            return}
        
        tabBar.buttons["Search"].tap()
        XCTAssert(app.navigationBars["Search News"].staticTexts["Search News"].exists)
        tabBar.buttons["notifications"].tap()
        XCTAssert(app.navigationBars["Reminded"].staticTexts["Reminded"].exists)
        tabBar.buttons["bookmark"].tap()
        XCTAssert(app.navigationBars["Saved"].staticTexts["Saved"].exists)
        tabBar.buttons["home"].tap()
        XCTAssert(app.navigationBars["Time Line"].staticTexts["Time Line"].exists)
        
        let tablesQuery = app.tables
        tablesQuery.cells.element(boundBy: 1).tap()
        
        XCTAssert (app.navigationBars.buttons["arrow.backward"].exists)
        app.navigationBars.buttons["arrow.backward"].tap()
        
    }
    
}
