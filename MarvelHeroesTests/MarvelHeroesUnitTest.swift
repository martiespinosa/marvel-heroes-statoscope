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
    
    static let emptyResponseMock =
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
    """

    static let pageZeroResponseMock =
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
            "limit": 2,
            "total": 3,
            "count": 2,
            "results": [
            {
               "id":1011334,
               "name":"3-D Man",
               "description":"",
               "modified":"2014-04-29T14:18:17-0400",
               "thumbnail":{
                  "path":"http://i.annihil.us/u/prod/marvel/i/mg/c/e0/535fecbbb9784",
                  "extension":"jpg"
               },
               "resourceURI":"http://gateway.marvel.com/v1/public/characters/1011334",
               "comics":{
                  "available":2,
                  "collectionURI":"http://gateway.marvel.com/v1/public/characters/1011334/comics",
                  "items":[
                     {
                        "resourceURI":"http://gateway.marvel.com/v1/public/comics/21366",
                        "name":"Avengers: The Initiative (2007) #14"
                     },
                     {
                        "resourceURI":"http://gateway.marvel.com/v1/public/comics/24571",
                        "name":"Avengers: The Initiative (2007) #14 (SPOTLIGHT VARIANT)"
                     }
                  ],
                  "returned":12
               },
               "series":{
                  "available":3,
                  "collectionURI":"http://gateway.marvel.com/v1/public/characters/1011334/series",
                  "items":[
                     {
                        "resourceURI":"http://gateway.marvel.com/v1/public/series/1945",
                        "name":"Avengers: The Initiative (2007 - 2010)"
                     },
                     {
                        "resourceURI":"http://gateway.marvel.com/v1/public/series/2005",
                        "name":"Deadpool (1997 - 2002)"
                     },
                     {
                        "resourceURI":"http://gateway.marvel.com/v1/public/series/2045",
                        "name":"Marvel Premiere (1972 - 1981)"
                     }
                  ],
                  "returned":3
               },
               "stories":{
                  "available":11,
                  "collectionURI":"http://gateway.marvel.com/v1/public/characters/1011334/stories",
                  "items":[
                     {
                        "resourceURI":"http://gateway.marvel.com/v1/public/stories/19947",
                        "name":"Cover #19947",
                        "type":"cover"
                     }
                  ],
                  "returned":20
               },
               "events":{
                  "available":1,
                  "collectionURI":"http://gateway.marvel.com/v1/public/characters/1011334/events",
                  "items":[
                     {
                        "resourceURI":"http://gateway.marvel.com/v1/public/events/269",
                        "name":"Secret Invasion"
                     }
                  ],
                  "returned":1
               },
               "urls":[
                  {
                     "type":"detail",
                     "url":"http://marvel.com/characters/74/3-d_man?utm_campaign=apiRef&utm_source=bf569e30e03535d508b3ab5d4414e6ad"
                  },
                  {
                     "type":"wiki",
                     "url":"http://marvel.com/universe/3-D_Man_(Chandler)?utm_campaign=apiRef&utm_source=bf569e30e03535d508b3ab5d4414e6ad"
                  },
                  {
                     "type":"comiclink",
                     "url":"http://marvel.com/comics/characters/1011334/3-d_man?utm_campaign=apiRef&utm_source=bf569e30e03535d508b3ab5d4414e6ad"
                  }
               ]
            },
            {
               "id":1017100,
               "name":"A-Bomb (HAS)",
               "description":"Rick Jones has been Hulk's best bud since day one, but now he's more than a friend...he's a teammate! Transformed by a Gamma energy explosion, A-Bomb's thick, armored skin is just as strong and powerful as it is blue. And when he curls into action, he uses it like a giant bowling ball of destruction! ",
               "modified":"2013-09-18T15:54:04-0400",
               "thumbnail":{
                  "path":"http://i.annihil.us/u/prod/marvel/i/mg/3/20/5232158de5b16",
                  "extension":"jpg"
               },
               "resourceURI":"http://gateway.marvel.com/v1/public/characters/1017100",
               "comics":{
                  "available":4,
                  "collectionURI":"http://gateway.marvel.com/v1/public/characters/1017100/comics",
                  "items":[
                     {
                        "resourceURI":"http://gateway.marvel.com/v1/public/comics/47176",
                        "name":"FREE COMIC BOOK DAY 2013 1 (2013) #1"
                     },
                     {
                        "resourceURI":"http://gateway.marvel.com/v1/public/comics/40632",
                        "name":"Hulk (2008) #53"
                     },
                     {
                        "resourceURI":"http://gateway.marvel.com/v1/public/comics/40630",
                        "name":"Hulk (2008) #54"
                     },
                     {
                        "resourceURI":"http://gateway.marvel.com/v1/public/comics/40628",
                        "name":"Hulk (2008) #55"
                     }
                  ],
                  "returned":4
               },
               "series":{
                  "available":2,
                  "collectionURI":"http://gateway.marvel.com/v1/public/characters/1017100/series",
                  "items":[
                     {
                        "resourceURI":"http://gateway.marvel.com/v1/public/series/17765",
                        "name":"FREE COMIC BOOK DAY 2013 1 (2013)"
                     },
                     {
                        "resourceURI":"http://gateway.marvel.com/v1/public/series/3374",
                        "name":"Hulk (2008 - 2012)"
                     }
                  ],
                  "returned":2
               },
               "stories":{
                  "available":0,
                  "collectionURI":"http://gateway.marvel.com/v1/public/characters/1017100/stories",
                  "items":[],
                  "returned":7
               },
               "events":{
                  "available":0,
                  "collectionURI":"http://gateway.marvel.com/v1/public/characters/1017100/events",
                  "items":[
                  ],
                  "returned":0
               },
               "urls":[
                  {
                     "type":"detail",
                     "url":"http://marvel.com/characters/76/a-bomb?utm_campaign=apiRef&utm_source=bf569e30e03535d508b3ab5d4414e6ad"
                  },
                  {
                     "type":"comiclink",
                     "url":"http://marvel.com/comics/characters/1017100/a-bomb_has?utm_campaign=apiRef&utm_source=bf569e30e03535d508b3ab5d4414e6ad"
                  }
               ]
            }
            ]
        }
    }
    """
    static let expectedCharactersPageZero: [MarvelCharacterVM] = [
        MarvelCharacterVM(
            id: 1011334,
            name: "3-D Man",
            imageURL: URL(string: "https://i.annihil.us/u/prod/marvel/i/mg/c/e0/535fecbbb9784.jpg")!,
            description: ""
        ),
        MarvelCharacterVM(
            id: 1017100,
            name: "A-Bomb (HAS)",
            imageURL: URL(string: "https://i.annihil.us/u/prod/marvel/i/mg/3/20/5232158de5b16.jpg")!,
            description: "Rick Jones has been Hulk's best bud since day one, but now he's more than a friend...he's a teammate! Transformed by a Gamma energy explosion, A-Bomb's thick, armored skin is just as strong and powerful as it is blue. And when he curls into action, he uses it like a giant bowling ball of destruction! "
        )
    ]

    static let pageOneResponseMock =
    """
    {
        "code": 0,
        "status": "",
        "copyright": "",
        "attributionText": "",
        "attributionHTML": "",
        "etag": "",
        "data": {
            "offset": 2,
            "limit": 2,
            "total": 3,
            "count": 1,
            "results": [
                {"id":1009144,"name":"A.I.M.","description":"AIM is a terrorist organization bent on destroying the world.","modified":"2013-10-17T14:41:30-0400","thumbnail":{"path":"http://i.annihil.us/u/prod/marvel/i/mg/6/20/52602f21f29ec","extension":"jpg"},"resourceURI":"http://gateway.marvel.com/v1/public/characters/1009144","comics":{"available":53,"collectionURI":"http://gateway.marvel.com/v1/public/characters/1009144/comics","items":[{"resourceURI":"http://gateway.marvel.com/v1/public/comics/36763","name":"Ant-Man & Wasp (2010) #3"},{"resourceURI":"http://gateway.marvel.com/v1/public/comics/17553","name":"Avengers (1998) #67"},{"resourceURI":"http://gateway.marvel.com/v1/public/comics/7340","name":"Avengers (1963) #87"},{"resourceURI":"http://gateway.marvel.com/v1/public/comics/4214","name":"Avengers and Power Pack Assemble! (2006) #2"},{"resourceURI":"http://gateway.marvel.com/v1/public/comics/63217","name":"Avengers and Power Pack (2017) #3"},{"resourceURI":"http://gateway.marvel.com/v1/public/comics/63218","name":"Avengers and Power Pack (2017) #4"},{"resourceURI":"http://gateway.marvel.com/v1/public/comics/63219","name":"Avengers and Power Pack (2017) #5"},{"resourceURI":"http://gateway.marvel.com/v1/public/comics/63220","name":"Avengers and Power Pack (2017) #6"},{"resourceURI":"http://gateway.marvel.com/v1/public/comics/64790","name":"AVENGERS BY BRIAN MICHAEL BENDIS: THE COMPLETE COLLECTION VOL. 2 TPB (Trade Paperback)"},{"resourceURI":"http://gateway.marvel.com/v1/public/comics/103371","name":"Avengers Unlimited Infinity Comic (2022) #17"},{"resourceURI":"http://gateway.marvel.com/v1/public/comics/1170","name":"Avengers Vol. 2: Red Zone (Trade Paperback)"},{"resourceURI":"http://gateway.marvel.com/v1/public/comics/1214","name":"Avengers Vol. II: Red Zone (Trade Paperback)"},{"resourceURI":"http://gateway.marvel.com/v1/public/comics/12787","name":"Captain America (1998) #28"},{"resourceURI":"http://gateway.marvel.com/v1/public/comics/7513","name":"Captain America (1968) #132"},{"resourceURI":"http://gateway.marvel.com/v1/public/comics/7514","name":"Captain America (1968) #133"},{"resourceURI":"http://gateway.marvel.com/v1/public/comics/65466","name":"Captain America by Mark Waid, Ron Garney & Andy Kubert (Hardcover)"},{"resourceURI":"http://gateway.marvel.com/v1/public/comics/20367","name":"Defenders (1972) #57"},{"resourceURI":"http://gateway.marvel.com/v1/public/comics/31068","name":"Incredible Hulks (2010) #606 (VARIANT)"},{"resourceURI":"http://gateway.marvel.com/v1/public/comics/46168","name":"Indestructible Hulk (2012) #3"},{"resourceURI":"http://gateway.marvel.com/v1/public/comics/43944","name":"Iron Man (2012) #1"}],"returned":20},"series":{"available":36,"collectionURI":"http://gateway.marvel.com/v1/public/characters/1009144/series","items":[{"resourceURI":"http://gateway.marvel.com/v1/public/series/13082","name":"Ant-Man & Wasp (2010 - 2011)"},{"resourceURI":"http://gateway.marvel.com/v1/public/series/1991","name":"Avengers (1963 - 1996)"},{"resourceURI":"http://gateway.marvel.com/v1/public/series/354","name":"Avengers (1998 - 2004)"},{"resourceURI":"http://gateway.marvel.com/v1/public/series/23123","name":"Avengers and Power Pack (2017)"},{"resourceURI":"http://gateway.marvel.com/v1/public/series/1046","name":"Avengers and Power Pack Assemble! (2006)"},{"resourceURI":"http://gateway.marvel.com/v1/public/series/27689","name":"AVENGERS BY BRIAN MICHAEL BENDIS: THE COMPLETE COLLECTION VOL. 2 TPB (2017)"},{"resourceURI":"http://gateway.marvel.com/v1/public/series/35600","name":"Avengers Unlimited Infinity Comic (2022 - 2023)"},{"resourceURI":"http://gateway.marvel.com/v1/public/series/227","name":"Avengers Vol. 2: Red Zone (2003)"},{"resourceURI":"http://gateway.marvel.com/v1/public/series/271","name":"Avengers Vol. II: Red Zone (2003)"},{"resourceURI":"http://gateway.marvel.com/v1/public/series/1996","name":"Captain America (1968 - 1996)"},{"resourceURI":"http://gateway.marvel.com/v1/public/series/1997","name":"Captain America (1998 - 2002)"},{"resourceURI":"http://gateway.marvel.com/v1/public/series/23810","name":"Captain America by Mark Waid, Ron Garney & Andy Kubert (2017)"},{"resourceURI":"http://gateway.marvel.com/v1/public/series/3743","name":"Defenders (1972 - 1986)"},{"resourceURI":"http://gateway.marvel.com/v1/public/series/8842","name":"Incredible Hulks (2010 - 2011)"},{"resourceURI":"http://gateway.marvel.com/v1/public/series/16583","name":"Indestructible Hulk (2012 - 2014)"},{"resourceURI":"http://gateway.marvel.com/v1/public/series/2029","name":"Iron Man (1968 - 1996)"},{"resourceURI":"http://gateway.marvel.com/v1/public/series/16593","name":"Iron Man (2012 - 2014)"},{"resourceURI":"http://gateway.marvel.com/v1/public/series/23915","name":"Iron Man Epic Collection: Doom (2018)"},{"resourceURI":"http://gateway.marvel.com/v1/public/series/9718","name":"Marvel Adventures Super Heroes (2010 - 2012)"},{"resourceURI":"http://gateway.marvel.com/v1/public/series/1506","name":"MARVEL MASTERWORKS: CAPTAIN AMERICA (2005)"}],"returned":20},"stories":{"available":57,"collectionURI":"http://gateway.marvel.com/v1/public/characters/1009144/stories","items":[{"resourceURI":"http://gateway.marvel.com/v1/public/stories/10253","name":"When the Unliving Strike","type":"interiorStory"},{"resourceURI":"http://gateway.marvel.com/v1/public/stories/10255","name":"Cover #10255","type":"cover"},{"resourceURI":"http://gateway.marvel.com/v1/public/stories/10256","name":"The Enemy Within!","type":"interiorStory"},{"resourceURI":"http://gateway.marvel.com/v1/public/stories/10259","name":"Death Before Dishonor!","type":"interiorStory"},{"resourceURI":"http://gateway.marvel.com/v1/public/stories/10261","name":"Cover #10261","type":"cover"},{"resourceURI":"http://gateway.marvel.com/v1/public/stories/10262","name":"The End of A.I.M.!","type":"interiorStory"},{"resourceURI":"http://gateway.marvel.com/v1/public/stories/11921","name":"The Red Skull Lives!","type":"interiorStory"},{"resourceURI":"http://gateway.marvel.com/v1/public/stories/11930","name":"He Who Holds the Cosmic Cube","type":"interiorStory"},{"resourceURI":"http://gateway.marvel.com/v1/public/stories/11936","name":"The Maddening Mystery of the Inconceivable Adaptoid!","type":"interiorStory"},{"resourceURI":"http://gateway.marvel.com/v1/public/stories/11981","name":"If This Be... Modok","type":"interiorStory"},{"resourceURI":"http://gateway.marvel.com/v1/public/stories/11984","name":"A Time to Die -- A Time to Live!","type":"interiorStory"},{"resourceURI":"http://gateway.marvel.com/v1/public/stories/11995","name":"At the Mercy of the Maggia","type":"interiorStory"},{"resourceURI":"http://gateway.marvel.com/v1/public/stories/28233","name":"In Sin Airy X","type":"interiorStory"},{"resourceURI":"http://gateway.marvel.com/v1/public/stories/28971","name":"[The Brothers Part I]","type":"interiorStory"},{"resourceURI":"http://gateway.marvel.com/v1/public/stories/34426","name":"The Red Skull Lives!","type":"interiorStory"},{"resourceURI":"http://gateway.marvel.com/v1/public/stories/34435","name":"He Who Holds the Cosmic Cube","type":"interiorStory"},{"resourceURI":"http://gateway.marvel.com/v1/public/stories/34441","name":"The Maddening Mystery of the Inconceivable Adaptoid!","type":"interiorStory"},{"resourceURI":"http://gateway.marvel.com/v1/public/stories/34486","name":"If This Be... Modok","type":"interiorStory"},{"resourceURI":"http://gateway.marvel.com/v1/public/stories/34489","name":"A Time to Die -- A Time to Live!","type":"interiorStory"},{"resourceURI":"http://gateway.marvel.com/v1/public/stories/34500","name":"At the Mercy of the Maggia","type":"interiorStory"}],"returned":20},"events":{"available":0,"collectionURI":"http://gateway.marvel.com/v1/public/characters/1009144/events","items":[],"returned":0},"urls":[{"type":"detail","url":"http://marvel.com/characters/77/aim.?utm_campaign=apiRef&utm_source=bf569e30e03535d508b3ab5d4414e6ad"},{"type":"wiki","url":"http://marvel.com/universe/A.I.M.?utm_campaign=apiRef&utm_source=bf569e30e03535d508b3ab5d4414e6ad"},{"type":"comiclink","url":"http://marvel.com/comics/characters/1009144/aim.?utm_campaign=apiRef&utm_source=bf569e30e03535d508b3ab5d4414e6ad"}]}
            ]
        }
    }
    """
    static let expectedCharactersPageOne: [MarvelCharacterVM] = [
        MarvelCharacterVM(
            id: 1009144,
            name: "A.I.M.",
            imageURL: URL(string: "https://i.annihil.us/u/prod/marvel/i/mg/6/20/52602f21f29ec.jpg")!,
            description: "AIM is a terrorist organization bent on destroying the world."
        )
    ]
    
    func testFetchMarvelCharactersEmpty() async throws {
        var request: URLRequest?
        let result = try await MarvelAPI.fetchMarvelCharacters(
            provider: NetworkProvider { requested in
                request = requested
                return Self.emptyResponseMock.data(using: .utf8)!
            },
            dateProvider: SystemProvider {
                Date(timeIntervalSince1970: 0)
            },
            limit: 20,
            offset: 0
        )
        XCTAssertEqual(result, [])
        XCTAssertEqual(
            URLRequest(url: URL(string: "https://gateway.marvel.com/v1/public/characters?limit=20&offset=0&ts=0&apikey=bf569e30e03535d508b3ab5d4414e6ad&hash=f80250e4917dd35ddaab91744322993a")!),
            request
        )
    }
    
    func testFetchMarvelCharactersPageZero() async throws {
        var request: URLRequest?
        let result = try await MarvelAPI.fetchMarvelCharacters(
            provider: NetworkProvider { requested in
                request = requested
                return Self.pageZeroResponseMock.data(using: .utf8)!
            },
            dateProvider: SystemProvider {
                Date(timeIntervalSince1970: 0)
            },
            limit: 2,
            offset: 0
        )
        XCTAssertEqual(result.count, 2)
        XCTAssertEqual(
            URLRequest(url: URL(string: "https://gateway.marvel.com/v1/public/characters?limit=2&offset=0&ts=0&apikey=bf569e30e03535d508b3ab5d4414e6ad&hash=f80250e4917dd35ddaab91744322993a")!),
            request
        )
    }
    
    func testFetchMarvelCharactersPageOne() async throws {
        var request: URLRequest?
        let result = try await MarvelAPI.fetchMarvelCharacters(
            provider: NetworkProvider { requested in
                request = requested
                return Self.pageOneResponseMock.data(using: .utf8)!
            },
            dateProvider: SystemProvider {
                Date(timeIntervalSince1970: 0)
            },
            limit: 2,
            offset: 0
        )
        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(
            URLRequest(url: URL(string: "https://gateway.marvel.com/v1/public/characters?limit=2&offset=0&ts=0&apikey=bf569e30e03535d508b3ab5d4414e6ad&hash=f80250e4917dd35ddaab91744322993a")!),
            request
        )
    }
    
    func testListFlow() throws {
        try HeroesListView.ViewModel.GIVEN {
            HeroesListView.ViewModel()
                .injectObject(SystemProvider(date: {
                    Date(timeIntervalSince1970: 0)
                }))
        }
        .WHEN(.fetchCharacters)
        .THEN(\.isLoading, equals: true)
        .THEN(\.characters, equals: [])
        .THEN(\.searchText, equals: "")
        .THEN(\.errorMessage, equals: nil)
        .THEN(\.isBottomLoading, equals: false)
        .THEN_EnquedEffect(
            NetworkEffect(
                request: URLRequest(url: URL(string: "https://gateway.marvel.com/v1/public/characters?limit=20&offset=0&ts=0&apikey=bf569e30e03535d508b3ab5d4414e6ad&hash=f80250e4917dd35ddaab91744322993a")!)
            )
        )
        .FORK(
            .fetchCharactersCompleted(
                .failure(
                    URLError(.notConnectedToInternet)
                ),
                page: 0,
                searchTerm: nil
            )
        ) { sut in
            try sut
                .THEN(\.isLoading, equals: false)
                .THEN(\.characters, equals: [])
                .THEN(\.errorMessage,
                       equals: "Fallo en la solicitud")
                .THEN(\.searchText, equals: "")
                .THEN(\.isBottomLoading, equals: false)
                .WHEN(.userTapOnErrorAlert)
                .THEN(\.isLoading, equals: true)
                .THEN(\.characters, equals: [])
                .THEN(\.errorMessage, equals: nil)
                .THEN(\.searchText, equals: "")
                .THEN(\.isBottomLoading, equals: false)
                .THEN_EnquedEffect(
                    NetworkEffect(
                        request: URLRequest(url: URL(string: "https://gateway.marvel.com/v1/public/characters?limit=20&offset=0&ts=0&apikey=bf569e30e03535d508b3ab5d4414e6ad&hash=f80250e4917dd35ddaab91744322993a")!)
                    )
                )
        }
        .WHEN(
            .fetchCharactersCompleted(
                .success(
                    Self.pageZeroResponseMock.data(using: .utf8)!
                ),
                page: 0,
                searchTerm: nil
            )
        )
        .THEN(\.isLoading, equals: false)
        .THEN(\.characters, equals: Self.expectedCharactersPageZero)
        .THEN(\.searchText, equals: "")
        .THEN(\.errorMessage, equals: nil)
        .THEN(\.isBottomLoading, equals: false)
        .WHEN(.userScrolledToLastVisibleCell)
        .THEN(\.isLoading, equals: false)
        .THEN(\.characters, equals: Self.expectedCharactersPageZero)
        .THEN(\.searchText, equals: "")
        .THEN(\.errorMessage, equals: nil)
        .THEN(\.isBottomLoading, equals: true)
        .THEN_EnquedEffect(
            NetworkEffect(
                request: URLRequest(url: URL(string: "https://gateway.marvel.com/v1/public/characters?limit=20&offset=20&ts=0&apikey=bf569e30e03535d508b3ab5d4414e6ad&hash=f80250e4917dd35ddaab91744322993a")!)
            )
        )
        .WHEN(
            .fetchCharactersCompleted(
                .success(
                    Self.pageOneResponseMock.data(using: .utf8)!
                ),
                page: 1,
                searchTerm: nil
            )
        )
        .THEN(\.isLoading, equals: false)
        .THEN(\.characters, equals: Self.expectedCharactersPageZero + Self.expectedCharactersPageOne)
        .THEN(\.searchText, equals: "")
        .THEN(\.errorMessage, equals: nil)
        .THEN(\.isBottomLoading, equals: false)
        .runTest()
    }
    
    func testSearchFlow() throws {
        try HeroesListView.ViewModel.GIVEN {
            HeroesListView.ViewModel()
                .injectObject(SystemProvider(date: {
                    Date(timeIntervalSince1970: 0)
                }))
                .set(\.pageSize, 2)
        }
        .WHEN(.searchCharacters("3"))
        .THEN(\.isLoading, equals: false)
        .THEN(\.searchText, equals: "3")
        .THEN_NoEffects()
        .WHEN(.searchCharacters("3-"))
        .THEN(\.isLoading, equals: false)
        .THEN(\.searchText, equals: "3-")
        .THEN_NoEffects()
        .WHEN(.searchCharacters("3-D"))
        .THEN(\.isLoading, equals: true)
        .THEN(\.characters, equals: [])
        .THEN(\.searchText, equals: "3-D")
        .THEN(\.errorMessage, equals: nil)
        .THEN(\.isBottomLoading, equals: false)
        .THEN_EnquedEffect(
            NetworkEffect(
                request: URLRequest(url: URL(string: "https://gateway.marvel.com/v1/public/characters?nameStartsWith=3-d&limit=2&offset=0&ts=0&apikey=bf569e30e03535d508b3ab5d4414e6ad&hash=f80250e4917dd35ddaab91744322993a")!)
            )
        )
        // FORK ERROR
        .WHEN(
            .fetchCharactersCompleted(
                .success(
                    Self.pageZeroResponseMock.data(using: .utf8)!
                ),
                page: 0,
                searchTerm: "3-D"
            )
        )
        .THEN(\.isLoading, equals: false)
        .THEN(\.characters, equals: Self.expectedCharactersPageZero)
        .THEN(\.searchText, equals: "3-D")
        .THEN(\.errorMessage, equals: nil)
        .THEN(\.isBottomLoading, equals: false)
        .runTest()
    }
}
