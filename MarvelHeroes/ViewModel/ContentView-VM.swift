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
    
//    @Observable
//    final class ViewModel {
//        
//        var characters: [MarvelCharacterVM] = []
//        var errorMessage: String?
//        var isLoading = false
//        
//        var isShowingError: Bool { errorMessage != nil }
//        private var currentPage = 0
//        private var allCharactersLoaded = false
//        
//        func fetchCharacters() async {
//            isLoading = true
//            do {
//                let characters = try await MarvelAPI.fetchMarvelCharacters(
//                    provider: Providers.defaultNetworkProvider,
//                    dateProvider: Providers.defaultSystemProvider
//                )
//                self.characters = characters.map {
//                    MarvelCharacterVM(
//                        name: $0.name,
//                        imageURL: $0.thumbnail.url,
//                        description: $0.description ?? ""
//                    )
//                }
//            } catch {
//                self.errorMessage = error.localizedDescription
//                print("Error fetching characters: \(error)")
//            }
//            isLoading = false
//        }
//    }
    
    final class ViewModelV2: Statostore, ObservableObject {
        
        @Published var characters: [MarvelCharacterVM] = []
        @Published var errorMessage: String?
        @Published var isLoading = false
        @Published var isBottomLoading = false
        
        var isShowingError: Bool { errorMessage != nil }
        private var currentPage = 0
        private var allCharactersLoaded = false
        
        @Injected var systemProvider: SystemProvider
        
        enum When {
            case fetchCharacters
            case fetchCharactersCompleted(Result<Data, Error>, page: Int)
            case userTapOnErrorAlert
            case userScrollToBottom
        }
        
        func update(_ when: When) throws {
            switch when {
            case .fetchCharacters:
                try fetchCharacters()
            case .fetchCharactersCompleted(let response, let page):
                try fetchCharactersCompleted(response, page: page)
            case .userTapOnErrorAlert:
                errorMessage = nil
            case .userScrollToBottom:
                if !isLoading && !allCharactersLoaded {
                    try fetchCharacters()
                }
            }
        }
        
        private func fetchCharacters() throws {
            isLoading = true
            currentPage += 1
            let limit = 10
            let offset = currentPage * limit
            
            let req = try MarvelAPI.fetchMarvelCharactersRequest(
                limit: limit,
                offset: offset,
                dateProvider: systemProvider
            )
            
            effectsState.enqueue(
                NetworkEffect(request: req)
                    .map { result in
                        When.fetchCharactersCompleted(result, page: self.currentPage)
                    }
            )
        }
        
        private func fetchCharactersCompleted(_ result: Result<Data, Error>, page: Int) throws {
            switch result {
            case .success(let data):
                let response = try MarvelAPI.parseMarvelCharactersResponse(data: data)
                let newCharacters = response.map {
                    MarvelCharacterVM(
                        name: $0.name,
                        imageURL: $0.thumbnail.url,
                        description: $0.description ?? ""
                    )
                }
                
                self.characters.append(contentsOf: newCharacters)
                
                if newCharacters.isEmpty {
                    allCharactersLoaded = true
                }
                
            case .failure(let error):
                self.errorMessage = error.localizedDescription
                print("Error fetching characters: \(error)")
            }
            
            isLoading = false
        }
    }
}


//    .WHEN(.fetchCharacters)
//    .THEN(\.isLoading, equals: true)
//    .THEN(\.characters, equals: [])
//    .WHEN(.fetchCharactersCompleted(.success(Self.emptyResponseMock.data(using: .utf8)!)))
//    .THEN(\.isLoading, equals: false)
//    .THEN(\.characters, equals: [])
//.runTest()


//    .WHEN(.fetchCharacters)
//    .THEN(\.isLoading, equals: true)
//    .THEN(\.characters, equals: [])
//    .WHEN(.fetchCharactersCompleted(.failure(error)))
//    .THEN(\.isLoading, equals: false)
//    .THEN(\.characters, equals: [])
//    .THEN(\.errorMessage, equals: "Ha habido un error")
//    .WHEN(.userTapsUnErrorAlert)
//    .THEN(\.isLoading, equals: true)
//    .THEN(\.characters, equals: [])
//    .THEN(\.errorMessage, equals: nil)
//.runTest()
