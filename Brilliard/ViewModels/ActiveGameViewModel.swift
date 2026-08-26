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
    var game: Game?
    private var tableSessions: [TableSessionViewModel] = []
    private var context: ModelContext?
    
    init() { }
    
    func configure(game: Game, context: ModelContext) {
        configureGame(game: game)
        configureContext(context: context)
        self.tableSessions = game.tables
            .sorted{$0.number < $1.number}
            .map { TableSessionViewModel(table: $0, context: context) }
    }
    
    func configureContext(context: ModelContext) {
        guard self.context == nil else { return }
        self.context = context
        
    }
    
    func configureGame(game: Game) {
        guard self.game == nil else { return }
        self.game = game
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
        guard let game else { return [] }
        for session in tableSessions where session.timerEngine.isRunning {
            session.finishRound()
        }
        game.isActive = false
        game.finishedAt = Date()
        
        await MainActor.run {
            try? context?.save()
        }
        return PaymentCalculator.calculate(for: game)
    }
}
