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
    
    static var emptyResponseMock =                 """
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
"""
 
    func testFetchMarvelCharacters() async throws {
        var request: URLRequest?
        let result = try await MarvelAPI.fetchMarvelCharacters(
            provider: NetworkProvider { requested in
                request = requested
                return Self.emptyResponseMock.data(using: .utf8)!
            },
            dateProvider: SystemProvider {
                Date(timeIntervalSince1970: 0)
            }
        )
        XCTAssertEqual(result, [])
        XCTAssertEqual(
            URLRequest(url: URL(string: "https://gateway.marvel.com/v1/public/characters?ts=0&apikey=bf569e30e03535d508b3ab5d4414e6ad&hash=f80250e4917dd35ddaab91744322993a")!),
            request
        )
    }
    
    func testListFlow() throws {
        try ContentView.ViewModelV2.GIVEN {
            ContentView.ViewModelV2()
                .injectObject(SystemProvider(date: {
                    Date(timeIntervalSince1970: 0)
                }))
        }
        .WHEN(.fetchCharacters)
        .THEN(\.isLoading, equals: true)
        .THEN(\.characters, equals: [])
        .THEN_EnquedEffect(
            NetworkEffect(
                request: URLRequest(url: URL(string: "https://gateway.marvel.com/v1/public/characters?ts=0&apikey=bf569e30e03535d508b3ab5d4414e6ad&hash=f80250e4917dd35ddaab91744322993a")!)
            )
        )
        .WHEN(.fetchCharactersCompleted(Self.emptyResponseMock.data(using: .utf8)!))
        .THEN(\.isLoading, equals: false)
        .THEN(\.characters, equals: [])
        .runTest()
    }
}
