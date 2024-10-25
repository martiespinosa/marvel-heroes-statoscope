//
//  ContentView.swift
//  MarvelHeroes
//
//  Created by Martí Espinosa Farran on 21/10/24.
//

import Statoscope
import SwiftUI

struct ContentView: View {
    
    @StateObject private var vm = ViewModelV2()
        .injectObject(Providers.defaultNetworkProvider)
        .injectObject(Providers.defaultSystemProvider)
    
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
            .alert("Error", isPresented: .constant(vm.isShowingError), actions: {
                Button("OK") {
                    vm.send(.userTapOnErrorAlert)
                }
            }, message: {
                Text(vm.errorMessage ?? "Unknown error")
            })
            .navigationTitle("Marvel Heroes")
        }
        .onAppear {
            StatoscopeLogger.logLevel = [.errors, .when, .effects, /*.stateDiff,*/ .injection]
            vm.send(.fetchCharacters)
        }
    }
}

#Preview {
    ContentView()
}

#Preview {
    ContentView()
}
