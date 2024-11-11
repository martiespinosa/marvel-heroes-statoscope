//
//  MarvelHeroesApp.swift
//  MarvelHeroes
//
//  Created by Martí Espinosa Farran on 21/10/24.
//

import SwiftUI
import Statoscope

@main
struct MarvelHeroesApp: App {
    init() {
        StatoscopeLogger.logLevel = [.errors, .when, .effects, /*.stateDiff, .injection */]
    }
    
    @StateObject var mainViewModel = HeroesListView.HeroesListVM()
        .injectObject(Providers.defaultNetworkProvider)
        .injectObject(Providers.defaultSystemProvider)

    var body: some Scene {
        WindowGroup {
            HeroesListView(vm: mainViewModel)
        }
    }
}
