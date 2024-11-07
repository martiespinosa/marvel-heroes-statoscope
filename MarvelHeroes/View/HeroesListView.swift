//
//  ContentView.swift
//  MarvelHeroes
//
//  Created by Martí Espinosa Farran on 21/10/24.
//

import Statoscope
import SwiftUI

struct HeroesListView: View {
    
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
                                    .environmentObject(HeroDetailView.ViewModel()
                                        .injectObject(Providers.defaultNetworkProvider)
                                        .injectObject(Providers.defaultSystemProvider)
                                    )
                            } label: {
                                HeroRowView(hero: character)
                            }
                            .onAppear {
                                if character == vm.characters.last {
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
//            .searchable(text: vm.bind(\.searchText, { ContentView.ViewModel.When.searchCharacters($0) }))
            .searchable(text: $vm.searchText)
            .onChange(of: vm.searchText) { _, newValue in
                if newValue.isEmpty {
                    vm.characters.removeAll()
                    vm.send(.fetchCharacters)
                } else {
                    vm.send(.searchCharacters(newValue))
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
//            StatoscopeLogger.logLevel = [.errors, .when, .effects, /*.stateDiff,*/ .injection]
            vm.send(.fetchCharacters)
        }
    }
}

#Preview {
    HeroesListView()
        .environmentObject(HeroesListView.ViewModel()
            .injectObject(Providers.defaultNetworkProvider)
            .injectObject(Providers.defaultSystemProvider))
}

#Preview {
    HeroesListView()
        .environmentObject(HeroesListView.ViewModel()
            .set(\.errorMessage, "Ha habido un error")
            .injectObject(Providers.defaultNetworkProvider)
            .injectObject(Providers.defaultSystemProvider))
}

#Preview {
    HeroesListView()
        .environmentObject(HeroesListView.ViewModel()
            .set(\.isBottomLoading, true)
            .set(\.characters, [.example])
            .injectObject(Providers.defaultNetworkProvider)
            .injectObject(Providers.defaultSystemProvider))
}
