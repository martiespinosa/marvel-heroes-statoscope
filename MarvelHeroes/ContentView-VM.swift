//
//  MarvelViewModel.swift
//  MarvelHeroes
//
//  Created by Martí Espinosa Farran on 21/10/24.
//

import Foundation
import Combine

extension ContentView {
    
    @Observable
    class ViewModel: ObservableObject {
        
        var characters: [MarvelCharacter] = []
        var errorMessage: String?
        var isLoading = false
        
        func fetchCharacters() async {
            isLoading = true
            do {
                let characters = try await MarvelAPI.fetchMarvelCharacters()
                self.characters = characters
            } catch {
                self.errorMessage = error.localizedDescription
                print("Error fetching characters: \(error)")
            }
            isLoading = false
        }
    }
}
