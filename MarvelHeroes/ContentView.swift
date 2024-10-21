//
//  ContentView.swift
//  MarvelHeroes
//
//  Created by Martí Espinosa Farran on 21/10/24.
//

import Statoscope
import SwiftUI

struct ContentView: View {
    
    @State private var vm = ViewModel()
    
    var body: some View {
        VStack {
            Text("Marvel Heroes")
        }
        .onAppear {
            Task {
                await vm.fetchCharacters()
            }
        }
        .onChange(of: vm.characters) {
            print(vm.characters.map { $0.name }.joined(separator: "\n"))
            print(vm.characters.map { $0.thumbnail.url })
        }
    }
}

#Preview {
    ContentView()
}
