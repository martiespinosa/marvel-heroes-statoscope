//
//  HeroView.swift
//  MarvelHeroes
//
//  Created by Martí Espinosa Farran on 21/10/24.
//

import SwiftUI

struct HeroRowView: View {
    
    let hero: MarvelCharacterVM
    
    var body: some View {
        HStack(alignment: .top) {
            AsyncImage(url: hero.imageURL) { image in
                image
                    .resizable()
                    .scaledToFit()
                    .clipShape(.rect(cornerRadius: 5))
                
            } placeholder: {
                EmptyView()
            }
            .frame(width: 50, height: 50)
            
            VStack(alignment: .leading) {
                Text(hero.name)
                    .font(.headline)
                Text(hero.description)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
            }
        }
    }
}

#Preview {
    HeroRowView(hero: .example)
}
