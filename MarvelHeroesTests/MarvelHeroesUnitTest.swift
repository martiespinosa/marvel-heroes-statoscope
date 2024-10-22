//
//  MarvelHeroesUnitTest.swift
//  MarvelHeroesTests
//
//  Created by Sergi Hernanz on 22/10/24.
//

import Foundation
import XCTest
import StatoscopeTesting
@testable import MarvelHeroes

final class MarvelHeroesUnitTest: XCTestCase {
    
    func testFetchMarvelCharacters() async throws {
        let result = try await MarvelAPI.fetchMarvelCharacters(
            provider: NetworkProvider { _ in
                """
{
    "code": 0,
    "status": "",
    "copyright": "",
    "attributionText": "",
    "attributionHTML": "",
    "etag": "",
    "data": {
        "offset": 0,
        "limit": 0,
        "total": 0,
        "count": 0,
        "results": []
    }
}
""".data(using: .utf8)!
            }
        )
        
        XCTAssertEqual(result, [])
    }
    
    func testListFlow() throws {
        try ContentView.ViewModelV2.GIVEN {
            ContentView.ViewModelV2()
        }
        .WHEN(.fetchCharacters)
        .THEN(\.isLoading, equals: true)
        .THEN(\.characters, equals: [])
        .WHEN(.fetchCharactersCompleted([]))
        .THEN(\.isLoading, equals: false)
        .THEN(\.characters, equals: [])
        .runTest()
    }
}
