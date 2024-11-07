//
//  HeroDetailView-VM.swift
//  MarvelHeroes
//
//  Created by Martí Espinosa Farran on 11/7/24.
//

import Foundation
import Combine
import Statoscope
import SwiftUI

struct MarvelComicVM: Equatable, Identifiable {
    var id: Int
    let title: String
    let imageURL: URL
    let description: String
    
    static let example: Self = .init(
        id: 40628,
        title: "Hulk (2008) #55",
        imageURL: URL(string: "https://i.annihil.us/u/prod/marvel/i/mg/6/60/5ba3d0869c543.jpg")!,
        description: "The hands of the doomsday clock race towards MAYAN RULE! Former Avengers arrive to help stop the end of the world as more Mayan gods return. Rick \"A-Bomb\" Jones falls in battle!"
    )
    
    init(id: Int, title: String, imageURL: URL, description: String) {
        self.id = id
        self.title = title
        self.imageURL = imageURL
        self.description = description
    }
}

extension HeroDetailView {
    final class ViewModel: Statostore, ObservableObject {
        
        @Published var comics: [MarvelComicVM] = []
        @Published var isLoading = false
        
        @Injected var systemProvider: SystemProvider
        
        enum When {
            case fetchComics(heroId: Int)
            case fetchComicsCompleted(Result<Data, Error>)
        }
        
        func update(_ when: When) throws {
            switch when {
            case .fetchComics(let heroId):
                try fetchComics(heroId: heroId)
            case .fetchComicsCompleted(let response):
                try fetchComicsCompleted(response)
            }
        }
        
        private func fetchComics(heroId: Int) throws {
            isLoading = true
            
            let req = try MarvelAPI.fetchMarvelComicsByHeroIdRequest(
                heroId: heroId,
                dateProvider: systemProvider
            )
            
            effectsState.enqueue(
                NetworkEffect(request: req)
                    .map { result in
                        When.fetchComicsCompleted(result)
                    }
            )
        }
        
        private func fetchComicsCompleted(_ result: Result<Data, Error>) throws {
            switch result {
            case .success(let data):
                let response = try MarvelAPI.parseMarvelComicsResponse(data: data)
                let newComics = response.map {
                    MarvelComicVM(
                        id: $0.id,
                        title: $0.title,
                        imageURL: $0.thumbnail.url,
                        description: $0.description ?? ""
                    )
                }
                comics.append(contentsOf: newComics)
            case .failure(let error):
                print(error.localizedDescription)
            }
            isLoading = false
        }
    }
}
