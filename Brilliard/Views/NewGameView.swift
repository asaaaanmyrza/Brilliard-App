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
    @State private var viewModel = NewGameViewModel()
    
//    var onCreated: (Game) -> Void
    
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
                    viewModel.addPlayerField()
                }) {
                    Image(systemName: "person.badge.plus")
                }
                .foregroundStyle(Color.secondary)
                .background(
                    Circle()
                        .foregroundStyle(.white)
                        .frame(width: 30, height: 30)
                )
            }
            ) {
                ForEach(viewModel.playerNames.indices, id: \.self) { i in
                    HStack {
                        TextField("Игрок \(i+1)", text: $viewModel.playerNames[i])
                    }
                }
                .onDelete { viewModel.playerNames.remove(atOffsets: $0) }
                
            }
            
            Button ("Начать игру!") {
                
            }
        }
    }
}

#Preview {
    NewGameView()
}
