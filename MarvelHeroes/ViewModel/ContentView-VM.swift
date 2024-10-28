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
    
    static let example: Self = .init(
        name: "A-Bomb (HAS)",
        imageURL: URL(string: "https://i.annihil.us/u/prod/marvel/i/mg/3/20/5232158de5b16.jpg")!,
        description: "Rick Jones has been Hulk's best bud since day one, but now he's more than a friend...he's a teammate! Transformed by a Gamma energy explosion, A-Bomb's thick, armored skin is just as strong and powerful as it is blue. And when he curls into action, he uses it like a giant bowling ball of destruction!"
    )
}

extension ContentView {
    final class ViewModel: Statostore, ObservableObject {

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
                    try fetchMoreCharacters()
                }
            }
        }
        
        private func fetchCharacters() throws {
            isLoading = true
            currentPage = 0
            let limit = 20
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
        
        private func fetchMoreCharacters() throws {
            isBottomLoading = true
            currentPage += 1
            let limit = 20
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
            isBottomLoading = false
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
