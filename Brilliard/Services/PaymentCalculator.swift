//
//  PaymentCalculator.swift
//  Brilliard
//
//  Created by Асан Мырзахметов on 06.08.2026.
//

import Foundation

struct PaymentResult: Identifiable {
    let id: UUID = UUID()
    let player: Player
    let minutes: Double
    let amount: Decimal
}

enum PaymentCalculator {
    func calculate(for game: Game) -> [PaymentResult] {
        let totalHours = game.rentedSeconds / 3600
        guard totalHours > 0 else { return [] }
        
        let totalCost = game.pricePerHour * Decimal(totalHours) * Decimal(game.tables.count)
        
        let totalPlayedSeconds = game.roster.reduce(0) { $0 + $1.totalSeconds }
        guard totalPlayedSeconds > 0 else { return [] }
        
        return game.roster
            .map { player in
                let weight = player.totalSeconds / totalPlayedSeconds
                return PaymentResult (
                    player: player,
                    minutes: player.totalSeconds / 60,
                    amount: totalCost * Decimal(weight)
                )
            }
            .sorted { $0.player.name < $1.player.name }
        
    }
}
