//
//  ComicView.swift
//  MarvelHeroes
//
//  Created by Martí Espinosa Farran on 11/8/24.
//

import SwiftUI

struct ComicView: View {
    
    let comic: MarvelComicVM
    
    var body: some View {
        HStack(alignment: .top) {
            AsyncImage(url: comic.imageURL) { image in
                image
                    .resizable()
                    .scaledToFit()
                    .clipShape(.rect(cornerRadius: 2.5))
            } placeholder: {
                EmptyView()
            }
            .frame(height: 65)
            
            VStack(alignment: .leading) {
                Text(comic.title)
                    .font(.headline)
                    .lineLimit(1)
                Text(comic.description)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
            }
        }
    }
}

#Preview {
    ComicView(comic: .example)
}
