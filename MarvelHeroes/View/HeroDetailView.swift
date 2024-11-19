//
//  HeroDetailView.swift
//  MarvelHeroes
//
//  Created by Martí Espinosa Farran on 21/10/24.
//

import Statoscope
import SwiftUI

struct HeroDetailView: View {
    
    @ObservedObject var vm: HeroDetailVM
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                AsyncImage(url: vm.character.imageURL) { image in
                    image
                        .resizable()
                        .scaledToFit()
                        .clipShape(.rect(cornerRadius: 10))
                    
                } placeholder: {
                    EmptyView()
                }
                .frame(maxWidth: .infinity)
                
                Text(vm.character.description)
                    .foregroundStyle(.secondary)
                
                VStack(alignment: .leading) {
                    Text("comicsText")
                        .font(.title2)
                        .fontWeight(.semibold)
                    
                    if vm.isLoading {
                        ProgressView()
                    } else {
                        ForEach(vm.comics) { comic in
                            ComicView(comic: comic)
                        }
                    }
                }
            }
        }
        .onAppear {
            vm.send(.fetchComics)
        }
        .padding(.horizontal)
        .scrollBounceBehavior(.basedOnSize)
        .navigationTitle(vm.character.name)
    }
}

#Preview {
    HeroDetailView(
        vm: HeroDetailView.HeroDetailVM(
            character: .example
        )
        .injectObject(Providers.defaultNetworkProvider)
        .injectObject(Providers.defaultSystemProvider)
    )
}
