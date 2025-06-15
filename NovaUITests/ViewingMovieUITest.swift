//
//  ViewingMovieUITest.swift
//  NovaUITests
//
//  Created by Mohamed Ameen on 16/06/25.
//

import XCTest

final class ViewMovieUITests: XCTestCase {
    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    // MARK: - 1. App Launch Test (Check for any movie title)
    func testAppLaunchesAndShowsMovieList() {
        let title = app.staticTexts.firstMatch
        XCTAssertTrue(title.waitForExistence(timeout: 5), "Movie title should be visible on launch")
    }

    // MARK: - 2. Check if at least one movie card exists in scrollView
    func testMoviesAreVisible() {
        let firstMovieCard = app.scrollViews.buttons.firstMatch
        XCTAssertTrue(firstMovieCard.waitForExistence(timeout: 5), "Movie card should be visible in carousel")
    }

    // MARK: - 3. Tap on a movie and check if detail screen appears
    func testTapOnMovieNavigatesToDetail() {
        let firstMovieCard = app.scrollViews.buttons.firstMatch
        XCTAssertTrue(firstMovieCard.waitForExistence(timeout: 5), "Movie card should be visible")
        firstMovieCard.tap()

        // Wait for detail view content (like title or overview)
        let detailText = app.staticTexts.firstMatch
        XCTAssertTrue(detailText.waitForExistence(timeout: 5), "Detail view should appear after tapping movie")
    }
}

