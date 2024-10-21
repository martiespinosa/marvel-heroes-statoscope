//
//  ContentView.swift
//  MarvelHeroes
//
//  Created by Martí Espinosa Farran on 21/10/24.
//

import Statoscope
import SwiftUI

struct ContentView: View {
    
    @State private var vm = ViewModel()
    
    var body: some View {
        NavigationStack {
            Group {
                if vm.isLoading {
                    ProgressView("Fetching Heroes…")
                } else {
                    List {
                        ForEach(vm.characters) { character in
                            NavigationLink {
                                HeroDetailView(hero: character)
                            } label: {
                                HeroView(hero: character)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Marvel Heroes")
        }
        .onAppear {
            Task {
                await vm.fetchCharacters()
            }
        }
        .onChange(of: vm.characters) {
            print(vm.characters.map { $0.name }.joined(separator: "\n"))
            print(vm.characters.map { $0.thumbnail.url })
        }
    }
}

#Preview {
    ContentView()
}
