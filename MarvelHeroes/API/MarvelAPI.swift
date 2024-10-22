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
        dateProvider: SystemProvider
    ) async throws -> [MarvelCharacter] {
        try parseMarveCharactersResponse(
            data: try await provider.fetchData(
                try fetchMarvelCharactersRequest(dateProvider: dateProvider)
            )
        )
    }
    
    static func fetchMarvelCharactersRequest(
        dateProvider: SystemProvider
    ) throws -> URLRequest {
        let publicKey = MarvelAPIKeys.publicKey
        let privateKey = MarvelAPIKeys.privateKey
        let timestamp = String(Int(dateProvider.date().timeIntervalSince1970))
        
        let hash = (timestamp + privateKey + publicKey).data(using: .utf8)!.md5()
        
        let urlString = "https://gateway.marvel.com/v1/public/characters?ts=\(timestamp)&apikey=\(publicKey)&hash=\(hash)"
        
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        return URLRequest(url: url)
    }
    
    static func parseMarveCharactersResponse(data: Data) throws -> [MarvelCharacter] {
        let decoder = JSONDecoder()
        let marvelResponse = try decoder.decode(MarvelResponse.self, from: data)
        return marvelResponse.data.results
    }
}

