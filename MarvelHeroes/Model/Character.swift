//
//  Character.swift
//  MarvelHeroes
//
//  Created by Martí Espinosa Farran on 21/10/24.
//

import Foundation

struct MarvelResponse: Codable {
    let code: Int
    let status: String
    let copyright: String
    let attributionText: String
    let attributionHTML: String
    let data: MarvelData
    let etag: String
}

struct MarvelData: Codable {
    let offset: Int
    let limit: Int
    let total: Int
    let count: Int
    let results: [MarvelCharacter]
}

struct MarvelCharacter: Codable, Equatable, Identifiable {
    let id: Int
    let name: String
    let description: String?
    let modified: String?
    let resourceURI: String
    let thumbnail: MarvelThumbnail
    
    static func == (lhs: MarvelCharacter, rhs: MarvelCharacter) -> Bool {
        lhs.id == rhs.id
    }
}

struct MarvelThumbnail: Codable {
    let path: String
    let `extension`: String
    
    var url: URL {
        let securePath = path.replacingOccurrences(of: "http://", with: "https://")
        return URL(string: "\(securePath).\(self.extension)")!
    }
}
