//
//  Response.swift
//  MarvelHeroes
//
//  Created by Martí Espinosa Farran on 11/7/24.
//

import Foundation

struct MarvelResponse<T: Codable>: Codable {
    let code: Int
    let status: String
    let copyright: String
    let attributionText: String
    let attributionHTML: String
    let data: MarvelData<T>
    let etag: String
}

struct MarvelData<T: Codable>: Codable {
    let offset: Int
    let limit: Int
    let total: Int
    let count: Int
    let results: [T]
}
