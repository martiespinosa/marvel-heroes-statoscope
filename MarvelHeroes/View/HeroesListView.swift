//
//  ContentView.swift
//  MarvelHeroes
//
//  Created by Martí Espinosa Farran on 21/10/24.
//

import Statoscope
import SwiftUI

struct HeroesListView: View {
    
    @ObservedObject var vm: HeroesListVM
        
    var body: some View {
        NavigationStack {
            Group {
                if vm.isLoading {
                    ProgressView("fetchingText")
                } else {
                    let listSelectionBinding: Binding<Int?> = vm.bind(
                       \.detail?.character.id,
                        HeroesListView.HeroesListVM.When.navigateToDetail
                    )
                    List(vm.characters, selection: listSelectionBinding) { character in
                        HeroRowView(hero: character)
                            .onAppear {
                                if character == vm.characters.last {
                                    vm.send(.userScrolledToLastVisibleCell)
                                }
                            }
                    }
                    .navigationDestination(item: listSelectionBinding) { item in
                        if let selectedVM = vm.detail {
                            HeroDetailView(vm: selectedVM)
                        } else {
                            EmptyView()
                        }
                    }
                    if vm.isBottomLoading {
                        Section(footer: Text("loadingText")) {
                            EmptyView()
                        }
                        .frame(maxWidth: .infinity, alignment: .center)
                    }
                }
            }
            .searchable(text: vm.bind(\.searchText, { HeroesListView.HeroesListVM.When.searchCharacters($0) }))
            .alert("errorText", isPresented: .constant(vm.isShowingError), actions: {
                Button("okText") {
                    vm.send(.userTapOnErrorAlert)
                }
            }, message: {
                Text(vm.errorMessage ?? "Unknown error")
            })
            .navigationTitle("titleText")
        }
        .onAppear {
            vm.send(.fetchCharacters)
        }
    }
}

#Preview {
    HeroesListView(vm: HeroesListView.HeroesListVM()
        .injectObject(Providers.defaultNetworkProvider)
        .injectObject(Providers.defaultSystemProvider))
}

#Preview {
    HeroesListView(vm: HeroesListView.HeroesListVM()
            .set(\.errorMessage, "Ha habido un error")
            .injectObject(Providers.defaultNetworkProvider)
            .injectObject(Providers.defaultSystemProvider))
}

#Preview {
    HeroesListView(vm: HeroesListView.HeroesListVM()
            .set(\.isBottomLoading, true)
            .set(\.characters, [.example])
            .injectObject(Providers.defaultNetworkProvider)
            .injectObject(Providers.defaultSystemProvider))
}
