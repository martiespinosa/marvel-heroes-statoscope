//
//  NetworkProvider.swift
//  MarvelHeroes
//
//  Created by Sergi Hernanz on 22/10/24.
//

import Foundation

struct NetworkProvider {
    let fetchData: (URLRequest) async throws -> Data
}

extension Providers {
    static var defaultNetworkProvider = NetworkProvider(
        fetchData: {
            try await URLSession.shared.data(for: $0).0
        }
    )
}
