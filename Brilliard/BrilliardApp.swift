//
//  BrilliardApp.swift
//  Brilliard
//
//  Created by Асан Мырзахметов on 06.08.2026.
//

import SwiftUI
import SwiftData

@main
struct BrilliardApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [Game.self, Player.self, Table.self, Round.self])
    }
}
