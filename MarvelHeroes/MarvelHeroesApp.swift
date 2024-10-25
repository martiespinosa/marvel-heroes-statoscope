//
//  MarvelHeroesApp.swift
//  MarvelHeroes
//
//  Created by Martí Espinosa Farran on 21/10/24.
//

import SwiftUI

@main
struct MarvelHeroesApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(ContentView.ViewModelV2()
                    .injectObject(Providers.defaultNetworkProvider)
                    .injectObject(Providers.defaultSystemProvider))
        }
    }
}
