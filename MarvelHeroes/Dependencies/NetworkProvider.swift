//
//  NetworkProvider.swift
//  MarvelHeroes
//
//  Created by Sergi Hernanz on 22/10/24.
//

import Foundation
import Statoscope

struct NetworkProvider {
    let fetchData: (URLRequest) async throws -> Data
}

struct NetworkEffect: Effect, Equatable {
    typealias ResultType = Data
    let request: URLRequest
    func runEffect() async throws -> Data {
        try await Providers.defaultNetworkProvider.fetchData(request)
    }
}

extension Providers {
    static var defaultNetworkProvider = NetworkProvider(
        fetchData: {
            try await URLSession.shared.data(for: $0).0
        }
    )
}
