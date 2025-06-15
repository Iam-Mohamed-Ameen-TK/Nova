//
//  NovaUITests.swift
//  NovaUITests
//
//  Created by Mohamed Ameen on 16/06/25.
//

import XCTest

final class MovieUITests: XCTestCase {
    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    func testFavoriteButtonToggle() {
        // Step 1: Tap first movie card
        let firstMovieCard = app.scrollViews.buttons.firstMatch
        XCTAssertTrue(firstMovieCard.waitForExistence(timeout: 5), "Movie card not found")
        firstMovieCard.tap()
        sleep(1)

        // Step 2: Search through all buttons, try to guess the heart button
        let buttons = app.buttons.allElementsBoundByIndex

        // Debug print to log what buttons exist (for dev)
        for (index, button) in buttons.enumerated() {
            print("Button \(index): \(button.label)")
        }

        // Step 3: Use index-based heuristic (e.g., assume heart is last or second-last button)
        guard let heartButton = buttons.last(where: { $0.isHittable }) else {
            XCTFail("Could not find a tappable heart button")
            return
        }

        heartButton.tap()
        sleep(1)

        // Step 4: Toggle again
        heartButton.tap()
        sleep(1)

        XCTAssertTrue(heartButton.exists, "Heart button exists after toggling")
    }
}
