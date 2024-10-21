//
//  HeroDetailView.swift
//  MarvelHeroes
//
//  Created by Martí Espinosa Farran on 21/10/24.
//

import SwiftUI

struct HeroDetailView: View {
    
    let hero: MarvelCharacter
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                AsyncImage(url: hero.thumbnail.url) { image in
                    image
                        .resizable()
                        .scaledToFit()
                        .clipShape(.rect(cornerRadius: 10))
                    
                } placeholder: {
                    EmptyView()
                }
                .frame(maxWidth: .infinity)
                
                Text(hero.name)
                    .font(.headline)
                
                Text(hero.description ?? "")
                    .foregroundStyle(.secondary)
            }
        }
        .padding()
        .navigationTitle("Hero Details")
    }
}

//#Preview {
//    HeroDetailView()
//}
