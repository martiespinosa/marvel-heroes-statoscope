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
    var id: Int
    let name: String
    let imageURL: URL
    let description: String
    
    static let example: Self = .init(
        id: 1017100,
        name: "A-Bomb (HAS)",
        imageURL: URL(string: "https://i.annihil.us/u/prod/marvel/i/mg/3/20/5232158de5b16.jpg")!,
        description: "Rick Jones has been Hulk's best bud since day one, but now he's more than a friend...he's a teammate! Transformed by a Gamma energy explosion, A-Bomb's thick, armored skin is just as strong and powerful as it is blue. And when he curls into action, he uses it like a giant bowling ball of destruction!"
    )
    
    init(id: Int, name: String, imageURL: URL, description: String) {
        self.id = id
        self.name = name
        self.imageURL = imageURL
        self.description = description
    }
}

extension HeroesListView {
    final class HeroesListVM: Statostore, ObservableObject {

        @Published var characters: [MarvelCharacterVM] = []

        @Published var searchText = ""
        
        @Published var errorMessage: String?
        @Published var isLoading = false
        @Published var isBottomLoading = false
        
        var isShowingError: Bool { errorMessage != nil }
        
        private var currentPage = 0
        var pageSize = 20
        private var allCharactersLoaded = false
        static private var minimumCharactersForSearch = 3
        
        @Injected var systemProvider: SystemProvider
        
        @Subscope var detail: HeroDetailView.HeroDetailVM?
                
        enum When {
            case fetchCharacters
            case fetchCharactersCompleted(Result<Data, Error>, page: Int, searchTerm: String?)
            case userTapOnErrorAlert
            case userScrolledToLastVisibleCell
            case searchCharacters(String)
            case navigateToDetail(Int?)
        }
        
        func update(_ when: When) throws {
            switch when {
            case .fetchCharacters:
                try fetchCharacters(page: 0)
            case .fetchCharactersCompleted(let response, let page, let searchTerm):
                try fetchCharactersCompleted(response, page: page, searchTerm: searchTerm)
            case .userTapOnErrorAlert:
                errorMessage = nil
                try fetchCharacters(page: currentPage)
            case .userScrolledToLastVisibleCell:
                if !isLoading && !isBottomLoading && !allCharactersLoaded {
                    if searchText.count == 0 {
                        try fetchCharacters(page: currentPage + 1)
                    } else {
                        try fetchCharactersByName(page: currentPage + 1, searchText)
                    }
                }
            case .searchCharacters(let name):
                // Debounce
                guard name != self.searchText else {
                    return
                }
                
                self.searchText = name
                if name.isEmpty {
                    try fetchCharacters(page: 0)
                } else if name.count >= Self.minimumCharactersForSearch {
                    effectsState.cancelAllEffects()
                    try fetchCharactersByName(page: 0, name)
                }
            case .navigateToDetail(let id):
                guard let id else {
                    // self.detailId = nil
                    self.detail = nil
                    return
                }
                // guard self.detailId != id else {
                guard self.detail?.character.id != id else {
                    return
                }
                guard let character = self.characters.first(where: { $0.id == id }) else {
                    throw InvalidStateError()
                }
                // self.detailId = id
                self.detail = HeroDetailView.HeroDetailVM(character: character)
                self.detail?.send(.fetchComics)
            }
        }
        
        private func fetchCharacters(page: Int) throws {
            if page == 0 {
                characters.removeAll()
                isLoading = true
                isBottomLoading = false
            } else {
                isLoading = false
                isBottomLoading = true
            }
            currentPage = page
            let limit = pageSize
            let offset = currentPage * limit
            
            let req = try MarvelAPI.fetchMarvelCharactersRequest(
                limit: limit,
                offset: offset,
                dateProvider: systemProvider

            )
            
            effectsState.enqueue(
                NetworkEffect(request: req)
                    .map { result in
                        When.fetchCharactersCompleted(result, page: page, searchTerm: nil)
                    }
            )
        }
        
        private func fetchCharactersCompleted(_ result: Result<Data, Error>, page: Int, searchTerm: String?) throws {
            guard self.searchText == (searchTerm ?? ""),
                  self.currentPage == page else {
                return
            }
            
            switch result {
            case .success(let data):
                let response = try MarvelAPI.parseMarvelCharactersResponse(data: data)
                let newCharacters = response.map {
                    MarvelCharacterVM(
                        id: $0.id,
                        name: $0.name,
                        imageURL: $0.thumbnail.url,
                        description: $0.description ?? ""
                    )
                }
                characters.append(contentsOf: newCharacters)
                allCharactersLoaded = newCharacters.isEmpty
            case .failure(let error):
                errorMessage = "Fallo en la solicitud"
                print(error.localizedDescription)
            }
            isLoading = false
            isBottomLoading = false
        }
        
        private func fetchCharactersByName(page: Int, _ name: String) throws {
            if page == 0 {
                characters = []
                isLoading = true
                isBottomLoading = false
            } else {
                isLoading = false
                isBottomLoading = true
            }
            currentPage = page
            let limit = pageSize
            let offset = currentPage * limit
            
            let req = try MarvelAPI.fetchMarvelCharactersByNameRequest(
                name: name,
                limit: limit,
                offset: offset,
                dateProvider: systemProvider
            )
            
            effectsState.enqueue(
                NetworkEffect(request: req)
                    .map { result in
                        When.fetchCharactersCompleted(result, page: page, searchTerm: name)
                    }
            )
        }
    }
}
