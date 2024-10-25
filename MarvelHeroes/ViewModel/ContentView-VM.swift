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
    final class ViewModel {
        
        var characters: [MarvelCharacterVM] = []
        var errorMessage: String?
        var isLoading = false
        
        var isShowingError: Bool { errorMessage != nil }
        private var currentPage = 0
        private var allCharactersLoaded = false
        
        func fetchCharacters() async {
            isLoading = true
            do {
                let characters = try await MarvelAPI.fetchMarvelCharacters(
                    provider: Providers.defaultNetworkProvider,
                    dateProvider: Providers.defaultSystemProvider
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
        
        var isShowingError: Bool { errorMessage != nil }
        @Published private var currentPage = 0
        @Published private var allCharactersLoaded = false
        
        @Injected var systemProvider: SystemProvider
        
        enum When {
            case fetchCharacters
            case fetchCharactersCompleted(Data)
            case userTapOnErrorAlert
        }
        
        func update(_ when: When) throws {
            switch when {
            case .fetchCharacters:
                try fetchCharacters()
            case .fetchCharactersCompleted(let response):
                try fetchCharactersCompleted(response)
            case .userTapOnErrorAlert:
                errorMessage = nil
            }
        }
        
        private func fetchCharacters() throws {
            isLoading = true
            let req = try MarvelAPI.fetchMarvelCharactersRequest(
                dateProvider: systemProvider
            )
            effectsState.enqueue(
                NetworkEffect(request: req)
                    .map(When.fetchCharactersCompleted)
            )
        }
        
        private func fetchCharactersCompleted(_ data: Data) throws {
            print("starting fetching")
            let response = try MarvelAPI.parseMarvelCharactersResponse(data: data)
            print("continuing fetching")
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
