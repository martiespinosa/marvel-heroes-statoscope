//
//  Thumbnail.swift
//  MarvelHeroes
//
//  Created by Martí Espinosa Farran on 11/7/24.
//

import Foundation

struct MarvelThumbnail: Codable {
    let path: String
    let `extension`: String
    
    var url: URL {
        let securePath = path.replacingOccurrences(of: "http://", with: "https://")
        return URL(string: "\(securePath).\(self.extension)")!
    }
}
