//
//  NovaTests.swift
//  NovaTests
//
//  Created by Mohamed Ameen on 16/06/25.
//

import XCTest
@testable import Nova

final class MovieListViewModelTests: XCTestCase {

    @MainActor
    func testInitialMoviesArrayIsEmpty() {
        // GIVEN: A new instance of MovieListViewModel
        let viewModel = MovieListViewModel()

        // THEN: The movies array should be empty
        XCTAssertTrue(viewModel.movies.isEmpty)
    }
}

// MARK: - Sample Models for Testing

struct Movie: Decodable, Identifiable {
    let id: Int
    let title: String
    let overview: String
    let poster_path: String
    let release_date: String
    let vote_average: Double
    let original_language: String?
}

struct MovieResult: Decodable {
    let page: Int
    let results: [Movie]
    let total_pages: Int
    let total_results: Int
}

func testMovieResultDecoding() throws {
    // GIVEN: A valid JSON representing a MovieResult
    let json = """
    {
        "page": 1,
        "results": [
            {
                "id": 1,
                "title": "Sample Movie",
                "overview": "This is a test movie.",
                "poster_path": "/sample.jpg",
                "release_date": "2025-01-01",
                "vote_average": 8.5,
                "original_language": "en"
            }
        ],
        "total_pages": 1,
        "total_results": 1
    }
    """.data(using: .utf8)!

    // WHEN: Decoding the JSON into a MovieResult
    let decoded = try JSONDecoder().decode(MovieResult.self, from: json)

    // THEN: The result should contain one movie with correct title
    XCTAssertEqual(decoded.results.count, 1)
    XCTAssertEqual(decoded.results[0].title, "Sample Movie")
}
