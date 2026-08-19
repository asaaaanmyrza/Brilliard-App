//
//  ActiveGameViewModel.swift
//  Brilliard
//
//  Created by Асан Мырзахметов on 19.08.2026.
//

import Foundation
import SwiftData

@Observable
final class ActiveGameViewModel {
    let game: Game
    var tableSessions: [TableSessionViewModel]
    private let modelContext: ModelContext
    
    init(game: Game, modelContext: ModelContext) {
        self.game = game
        self.modelContext = modelContext
        self.tableSessions = game.tables
            .sorted{$0.number < $1.number}
            .map { TableSessionViewModel(table: $0, modelContext: modelContext) }
    }
    
    var busyPlayerIDs: Set<PersistentIdentifier> {
        Set(
            tableSessions
                .filter { $0.timerEngine.isRunning }
                .flatMap { $0.table.activeRound?.participants ?? [] }
                .map(\.persistentModelID)
        )
    }
    
    func finishGame() async -> [PaymentResult] {
        for session in tableSessions where session.timerEngine.isRunning {
            session.finishRound()
        }
        game.isActive = false
        game.finishedAt = Date()
        
        await MainActor.run {
            try? modelContext.save()
        }
        return PaymentCalculator.calculate(for: game)
    }
}
