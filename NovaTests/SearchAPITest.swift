//
//  SearchAPIYTest.swift
//  NovaTests
//
//  Created by Mohamed Ameen on 16/06/25.
//

import XCTest
@testable import Nova

// MARK: - MockURLProtocol

/// A mock URLProtocol to intercept network requests for unit testing.
class MockURLProtocol: URLProtocol {
    static var mockResponse: Data?
    static var mockError: Error?

    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }

    override func startLoading() {
        if let error = MockURLProtocol.mockError {
            // Simulate network error
            self.client?.urlProtocol(self, didFailWithError: error)
        } else if let data = MockURLProtocol.mockResponse {
            // Simulate successful data response
            self.client?.urlProtocol(self, didLoad: data)
            self.client?.urlProtocolDidFinishLoading(self)
        }
    }

    override func stopLoading() {}
}

// MARK: - MovieService

/// A real service class that performs actual search network calls using URLSession.
class MovieService {
    private let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }

    func search(keyword: String) async throws -> [Movie] {
        // Ensure the keyword is properly encoded and build the search URL
        guard let encodedKeyword = keyword.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: "https://api.themoviedb.org/3/search/movie?query=\(encodedKeyword)&api_key=0e6e9f8743ac3144e0a43faa485fe233")
        else {
            throw URLError(.badURL)
        }

        // Fetch data and decode the movie results
        let (data, _) = try await session.data(from: url)
        let movieResult = try JSONDecoder().decode(MovieResult.self, from: data)
        return movieResult.results
    }
}

// MARK: - MockMovieSearchService

/// A mock service used specifically for unit testing the response parsing logic.
final class MockMovieSearchService {
    
    func search(keyword: String) async throws -> [Movie] {
        // Simulated valid JSON data
        let json = """
        {
            "page": 1,
            "results": [
                {
                    "id": 123,
                    "title": "Inception",
                    "overview": "A mind-bending thriller.",
                    "poster_path": "/inception.jpg",
                    "release_date": "2010-07-16",
                    "vote_average": 8.8,
                    "original_language": "en"
                }
            ],
            "total_pages": 1,
            "total_results": 1
        }
        """.data(using: .utf8)!
        
        // Decode the mock JSON
        let decoded = try JSONDecoder().decode(MovieResult.self, from: json)
        return decoded.results
    }
}

// MARK: - Search API Unit Test

final class SearchAPITests: XCTestCase {
    
    func testSearchAPIResponseParsing() async throws {
        // GIVEN: A mock movie search service and a keyword
        let service = MockMovieSearchService()
        
        // WHEN: Performing a search for the keyword "inception"
        let movies = try await service.search(keyword: "inception")
        
        // THEN: The decoded movie data should match expected values
        XCTAssertEqual(movies.count, 1)
        XCTAssertEqual(movies[0].title, "Inception")
        XCTAssertEqual(movies[0].vote_average, 8.8)
        XCTAssertEqual(movies[0].original_language, "en")
    }
}
