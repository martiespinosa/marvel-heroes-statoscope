//
//  HeroDetailView.swift
//  MarvelHeroes
//
//  Created by Martí Espinosa Farran on 21/10/24.
//

import Statoscope
import SwiftUI

struct HeroDetailView: View {
    
    let hero: MarvelCharacterVM
    
    @EnvironmentObject var vm: ViewModel
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                AsyncImage(url: hero.imageURL) { image in
                    image
                        .resizable()
                        .scaledToFit()
                        .clipShape(.rect(cornerRadius: 10))
                    
                } placeholder: {
                    EmptyView()
                }
                .frame(maxWidth: .infinity)
                
                Text(hero.description)
                    .foregroundStyle(.secondary)
                
                if vm.isLoading {
                    ProgressView()
                } else {
                    ForEach(vm.comics) { comic in
                        Text(comic.title)
                    }
                }
            }
        }
        .onAppear {
            vm.send(.fetchComics(heroId: hero.id))
        }
        .padding(.horizontal)
        .scrollBounceBehavior(.basedOnSize)
        .navigationTitle(hero.name)
    }
}

#Preview {
    HeroDetailView(hero: .example)
}
