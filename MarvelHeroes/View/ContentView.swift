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
//    @State private var searchText = ""
        
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
                            .onAppear {
//                                let lastIndexMinusTen = vm.characters.count - 10
                                if !vm.isSearching && character == vm.characters.last {
                                    vm.send(.userScrolledToLastVisibleCell)
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
            .searchable(text: vm.bind(\.searchText, { ContentView.ViewModel.When.searchCharacters($0) }))
//            .onChange(of: vm.searchText) { _, newText in
//                if newText.isEmpty {
//                    vm.isSearching = false
//                    vm.send(.fetchCharacters)
//                } else {
//                    print("Buscando con texto: \(newText)")
//                    vm.isSearching = true
//                    try? vm.update(.searchCharacters(newText))
//                }
//            }
//            .onChange(of: vm.searchText) { oldValue, newText in
//                guard newText != oldValue else { return }
//                
//                if newText.isEmpty {
//                    try? vm.update(.fetchCharacters)
//                } else {
//                    try? vm.update(.searchCharacters(newText))
//                }
//            }
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
