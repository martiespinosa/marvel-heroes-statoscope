//
//  ContentView.swift
//  MarvelHeroes
//
//  Created by Martí Espinosa Farran on 21/10/24.
//

import Statoscope
import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var vm: ViewModel
    @State private var searchText = ""
    
    private var filteredCharacters: [MarvelCharacterVM] {
        if searchText.isEmpty {
            return vm.characters
        } else {
            return vm.characters.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    var body: some View {
        NavigationStack {
            Group {
                if vm.isLoading {
                    ProgressView("Fetching Heroes…")    
                } else {
                    List {
                        ForEach(filteredCharacters) { character in
                            NavigationLink {
                                HeroDetailView(hero: character)
                            } label: {
                                HeroView(hero: character)
                            }
                            .onAppear {
                                let lastIndexMinusTen = vm.characters.count - 10
                                if lastIndexMinusTen >= 0 && character == vm.characters[lastIndexMinusTen] {
                                    vm.send(.userScrollToBottom)
                                }
                            }
                        }
                        if vm.isBottomLoading {
                            Section(footer: Text("Loading more...")) {
                                EmptyView()
                            }
                            .frame(maxWidth: .infinity, alignment: .center)
                        }
                    }
                }
            }
            .searchable(text: $searchText)
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
        .environmentObject(ContentView.ViewModel()
            .injectObject(Providers.defaultNetworkProvider)
            .injectObject(Providers.defaultSystemProvider))
}

#Preview {
    ContentView()
        .environmentObject(ContentView.ViewModel()
            .set(\.errorMessage, "Ha habido un error")
            .injectObject(Providers.defaultNetworkProvider)
            .injectObject(Providers.defaultSystemProvider))
}

#Preview {
    ContentView()
        .environmentObject(ContentView.ViewModel()
            .set(\.isBottomLoading, true)
            .set(\.characters, [.example])
            .injectObject(Providers.defaultNetworkProvider)
            .injectObject(Providers.defaultSystemProvider))
}
