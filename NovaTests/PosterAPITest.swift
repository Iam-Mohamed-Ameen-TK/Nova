//
//  PosterAPITest.swift
//  NovaTests
//
//  Created by Mohamed Ameen on 16/06/25.
//

import XCTest
@testable import Nova

// MARK: - Mock Networking Service
final class MockMovieNetworkingService {
    
    func fetchMockMovies() async throws -> [Movie] {
        // Simulated valid JSON response
        let json = """
        {
            "page": 1,
            "results": [
                {
                    "id": 1,
                    "title": "Interstellar",
                    "overview": "A science fiction movie about space travel.",
                    "poster_path": "/interstellar.jpg",
                    "release_date": "2014-11-07",
                    "vote_average": 8.6,
                    "original_language": "en"
                }
            ],
            "total_pages": 1,
            "total_results": 1
        }
        """.data(using: .utf8)!
        
        let decoded = try JSONDecoder().decode(MovieResult.self, from: json)
        return decoded.results
    }
    
    func fetchCorruptedJSON() async throws -> [Movie] {
        // Simulated corrupted JSON missing required field
        let brokenJSON = """
        {
            "results": [
                {
                    "id": 1,
                    "title": "No Language Key",
                    "overview": "Testing missing fields.",
                    "poster_path": "/img.jpg",
                    "release_date": "2020-01-01",
                    "vote_average": 7.0
                }
            ],
            "total_pages": 1,
            "total_results": 1
        }
        """.data(using: .utf8)!
        
        let decoded = try JSONDecoder().decode(MovieResult.self, from: brokenJSON)
        return decoded.results
    }
}

// MARK: - Unit Tests
final class MovieNetworkingTests: XCTestCase {
    
    func testSuccessfulMovieFetchAndDecode() async throws {
        // GIVEN: A mock service with valid movie JSON
        let service = MockMovieNetworkingService()
        
        // WHEN: Fetching and decoding movies
        let movies = try await service.fetchMockMovies()
        
        // THEN: The movie should be decoded correctly
        XCTAssertEqual(movies.count, 1)
        XCTAssertEqual(movies[0].title, "Interstellar")
        XCTAssertEqual(movies[0].poster_path, "/interstellar.jpg")
    }
    
    func testDecodeFailsOnInvalidJSON() async {
        // GIVEN: A mock service with corrupted/missing JSON fields
        let service = MockMovieNetworkingService()
        
        // WHEN: Attempting to decode corrupted JSON
        do {
            _ = try await service.fetchCorruptedJSON()
            XCTFail("Decoding should fail due to missing 'original_language'")
        } catch {
            // THEN: A DecodingError should be thrown
            XCTAssertTrue(error is DecodingError)
        }
    }
    
    func testPosterURLGeneration() {
        // GIVEN: A poster path string
        func poster(_ path: String) -> URL? {
            return URL(string: "https://image.tmdb.org/t/p/w500\(path)")
        }
        
        let path = "/avatar.jpg"
        let expected = "https://image.tmdb.org/t/p/w500/avatar.jpg"
        
        // WHEN: Generating the poster URL
        
        // THEN: The result should match expected full URL
        XCTAssertEqual(poster(path)?.absoluteString, expected)
    }
}
