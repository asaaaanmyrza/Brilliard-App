//
//  NewGameView.swift
//  Brilliard
//
//  Created by Асан Мырзахметов on 20.08.2026.
//

import SwiftUI
import SwiftData

struct NewGameView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    
    @EnvironmentObject private var router: Router
    
    @State private var viewModel = NewGameViewModel()
    
    var body: some View {
        Form {
            Section ("Тариф (за час)") {
                TextField("Цена", value: $viewModel.pricePerHour, format: .currency(code: "KZT"))
                    .keyboardType(.decimalPad)
            }
            Section ("Количество столов") {
                Picker(selection: $viewModel.tableCount, label: Text("Количество столов")) {
                    ForEach (1..<11) {
                        Text("\($0)").tag($0)
                    }
                }
                .pickerStyle(.wheel)
                .frame(height:100)
            }
            Section (header:
                        HStack {
                Text("Игроки")
                Spacer()
                Button (action: {
                    withAnimation {
                        viewModel.addPlayerField()
                    }
                }) {
                    Image(systemName: "person.crop.circle.badge.plus")
                        .imageScale(.large)
                }
            }
            ) {
                ForEach(viewModel.players, id: \.id) { player in
                    let index = viewModel.players.firstIndex(where: { $0.id == player.id }) ?? 0
                    HStack {
                        @Bindable var bindablePlayer = player
                        TextField("Игрок \(index+1)", text: $bindablePlayer.name)
                    }
                }
                .onDelete { indexSet in
                    withAnimation {
                        indexSet.forEach { index in
                            viewModel.players.remove(at: index)
                        }
                    }
                    
                }
            }
            
            Button ("Начать игру!") {
                let game = viewModel.createGame(context: context)
                router.push(.activeGame(game: game))
                router.dismissSheet()
            }
        }
    }
}

    #Preview {
        NewGameView()
    }
