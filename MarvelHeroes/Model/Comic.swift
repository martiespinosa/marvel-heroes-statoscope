//
//  Comic.swift
//  MarvelHeroes
//
//  Created by Martí Espinosa Farran on 11/7/24.
//

import Foundation

struct MarvelComic: Codable {
    let id: Int
    let title: String
    let description: String?
    let pageCount: Int?
    let thumbnail: MarvelThumbnail
}
