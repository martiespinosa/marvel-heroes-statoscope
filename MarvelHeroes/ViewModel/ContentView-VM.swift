//
//  MarvelViewModel.swift
//  MarvelHeroes
//
//  Created by Martí Espinosa Farran on 21/10/24.
//

import Foundation
import Combine
import Statoscope
import SwiftUI

struct MarvelCharacterVM: Equatable, Identifiable {
    var id: String { name }
    
    let name: String
    let imageURL: URL
    let description: String
}

extension ContentView {
    
    @Observable
    class ViewModel: ObservableObject {
        
        var characters: [MarvelCharacterVM] = []
        var errorMessage: String?
        var isLoading = false
        
        func fetchCharacters() async {
            isLoading = true
            do {
                let characters = try await MarvelAPI.fetchMarvelCharacters(
                    provider: Providers.defaultNetworkProvider
                )
                self.characters = characters.map {
                    MarvelCharacterVM(
                        name: $0.name,
                        imageURL: $0.thumbnail.url,
                        description: $0.description ?? ""
                    )
                }
            } catch {
                self.errorMessage = error.localizedDescription
                print("Error fetching characters: \(error)")
            }
            isLoading = false
        }
    }
    
    final class ViewModelV2: Statostore, ObservableObject {
        
        @Published var characters: [MarvelCharacterVM] = []
        @Published var errorMessage: String?
        @Published var isLoading = false
        
        enum When {
            case fetchCharacters
            case fetchCharactersCompleted([MarvelCharacter])
        }
        
        func update(_ when: When) throws {
            switch when {
            case .fetchCharacters:
                self.fetchCharacters()
            case .fetchCharactersCompleted(let response):
                self.fetchCharactersCompleted(response)
            }
        }
        
        private func fetchCharacters() {
            isLoading = true
            effectsState.enqueue(
                AnyEffect {
                    try await MarvelAPI.fetchMarvelCharacters(
                        provider: Providers.defaultNetworkProvider
                    )
                }
                    .map(When.fetchCharactersCompleted)
            )
        }
        
        private func fetchCharactersCompleted(_ response: [MarvelCharacter]) {
            self.characters = response.map {
                MarvelCharacterVM(
                    name: $0.name,
                    imageURL: $0.thumbnail.url,
                    description: $0.description ?? ""
                )
            }
            isLoading = false
        }
    }
}
