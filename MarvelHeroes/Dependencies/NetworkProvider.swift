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
    typealias ResultType = Result<Data, Error>
    let request: URLRequest
    
    func runEffect() async throws -> Result<Data, Error> {
        do {
            let data = try await Providers.defaultNetworkProvider.fetchData(request)
            return .success(data)
        } catch {
            return .failure(error)
        }
    }
}

extension Providers {
    static var defaultNetworkProvider = NetworkProvider(
        fetchData: {
            try await URLSession.shared.data(for: $0).0
        }
    )
}
