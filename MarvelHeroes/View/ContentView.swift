//
//  ContentView.swift
//  MarvelHeroes
//
//  Created by Martí Espinosa Farran on 21/10/24.
//

import Statoscope
import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var vm: ViewModelV2
    
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
        .environmentObject(ContentView.ViewModelV2()
            .injectObject(Providers.defaultNetworkProvider)
            .injectObject(Providers.defaultSystemProvider))
}

#Preview {
    ContentView()
        .environmentObject(ContentView.ViewModelV2()
            .set(\.errorMessage, "Ha habido un error")
            .injectObject(Providers.defaultNetworkProvider)
            .injectObject(Providers.defaultSystemProvider))
}

#Preview {
    ContentView()
        .environmentObject(ContentView.ViewModelV2()
            .set(\.isBottomLoading, true)
            .set(\.characters, [MarvelCharacterVM(name: "Iron Man", imageURL: URL(string: "about:blank")!, description: "Iron man description")])
            .injectObject(Providers.defaultNetworkProvider)
            .injectObject(Providers.defaultSystemProvider))
}
