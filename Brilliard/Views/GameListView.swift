//
//  GameListView.swift
//  Brilliard
//
//  Created by Асан Мырзахметов on 20.08.2026.
//

import SwiftUI
import SwiftData

struct GameListView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    
    @EnvironmentObject private var router: Router
    
    @State private var viewModel = GameListViewModel()
    
    var body: some View {
        List {
            Section ("Активные игры") {
                ForEach(viewModel.activeGames, id: \.id) { game in
                    HStack {
                        Text("Active Game")
                    }
                }
            }
            Section ("История игр") {
                ForEach(viewModel.finishedGames, id: \.id) { game in
                    HStack {
                        Text("Finished Game")
                    }
                }
            }
        }
        .toolbar {
            Button("New Game") {
                router.presentSheet(.newGame)
            }
        }
        .task {
            viewModel.configure(context: context)
            viewModel.loadGames()
        }
    }
}

#Preview {
    GameListView()
}
