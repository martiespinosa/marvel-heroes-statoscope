//
//  SystemProvider.swift
//  MarvelHeroes
//
//  Created by Sergi Hernanz on 22/10/24.
//

import Foundation
import Statoscope

struct SystemProvider: Injectable {
    let date: () -> Date
    static var defaultValue: SystemProvider = Providers.defaultSystemProvider
}

extension Providers {
    static var defaultSystemProvider = SystemProvider(
        date: {
            Date()
        }
    )
}
