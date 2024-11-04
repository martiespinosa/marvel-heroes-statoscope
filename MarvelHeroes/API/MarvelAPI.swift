//
//  MarvelAPI.swift
//  MarvelHeroes
//
//  Created by Martí Espinosa Farran on 21/10/24.
//

import Foundation
import CommonCrypto
import Statoscope

extension Data {
    func md5() -> String {
        var hash = [UInt8](repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))
        self.withUnsafeBytes {
            _ = CC_MD5($0.baseAddress, CC_LONG(self.count), &hash)
        }
        return hash.map { String(format: "%02x", $0) }.joined()
    }
}

class MarvelAPI {
    
    static func fetchMarvelCharacters(
        provider: NetworkProvider,
        dateProvider: SystemProvider,
        limit: Int,
        offset: Int
    ) async throws -> [MarvelCharacter] {
        let request = try fetchMarvelCharactersRequest(limit: limit, offset: offset, dateProvider: dateProvider)
        return try parseMarvelCharactersResponse(
            data: try await provider.fetchData(request)
        )
    }
    
    static func fetchMarvelCharactersRequest(
        limit: Int,
        offset: Int,
        dateProvider: SystemProvider
    ) throws -> URLRequest {
        let publicKey = MarvelAPIKeys.publicKey
        let privateKey = MarvelAPIKeys.privateKey
        let timestamp = String(Int(dateProvider.date().timeIntervalSince1970))
        
        let hash = (timestamp + privateKey + publicKey).data(using: .utf8)!.md5()
        
        let urlString = "https://gateway.marvel.com/v1/public/characters?limit=\(limit)&offset=\(offset)&ts=\(timestamp)&apikey=\(publicKey)&hash=\(hash)"
        
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        print("fetching marvel characters")
        return URLRequest(url: url)
    }
    
    static func fetchMarvelCharactersByName(
        provider: NetworkProvider,
        dateProvider: SystemProvider,
        name: String,
        limit: Int,
        offset: Int
    ) async throws -> [MarvelCharacter] {
        let request = try fetchMarvelCharactersByNameRequest(name: name, limit: limit, offset: offset, dateProvider: dateProvider)
        return try parseMarvelCharactersResponse(
            data: try await provider.fetchData(request)
        )
    }
    
    static func fetchMarvelCharactersByNameRequest(
        name: String,
        limit: Int,
        offset: Int,
        dateProvider: SystemProvider
    ) throws -> URLRequest {
        let publicKey = MarvelAPIKeys.publicKey
        let privateKey = MarvelAPIKeys.privateKey
        let timestamp = String(Int(dateProvider.date().timeIntervalSince1970))
        
        let hash = (timestamp + privateKey + publicKey).data(using: .utf8)!.md5()
        
        guard let encodedName = name.lowercased().addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            throw URLError(.badURL)
        }
        
        let urlString = "https://gateway.marvel.com/v1/public/characters?nameStartsWith=\(encodedName)&limit=\(limit)&offset=\(offset)&ts=\(timestamp)&apikey=\(publicKey)&hash=\(hash)"
        print("URL de búsqueda generada: \(urlString)")
        
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        print("Fetching Marvel characters by name: \(name)")
        return URLRequest(url: url)
    }
    
    static func parseMarvelCharactersResponse(data: Data) throws -> [MarvelCharacter] {
//        print("Datos recibidos:", String(data: data, encoding: .utf8) ?? "Datos vacíos")
        let decoder = JSONDecoder()
        let marvelResponse = try decoder.decode(MarvelResponse.self, from: data)
        return marvelResponse.data.results
    }
}

