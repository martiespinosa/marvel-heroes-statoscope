//
//  Character.swift
//  MarvelHeroes
//
//  Created by Martí Espinosa Farran on 21/10/24.
//

import Foundation

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
