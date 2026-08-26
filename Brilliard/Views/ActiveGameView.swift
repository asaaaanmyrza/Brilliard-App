//
//  ActiveGameView.swift
//  Brilliard
//
//  Created by Асан Мырзахметов on 20.08.2026.
//

import SwiftUI
import SwiftData

struct ActiveGameView: View {
    @Environment(\.modelContext) var context
    
    @EnvironmentObject private var router: Router
    
    @State private var viewModel = ActiveGameViewModel()
    
    var game: Game
    
    var body: some View {
        Button ("Finish Game") {
            Task {
                await viewModel.finishGame()
            }
            router.pop()
        }
        .task {
            viewModel.configure(game: game, context: context)
        }
    }
}
