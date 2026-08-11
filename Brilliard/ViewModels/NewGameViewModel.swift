//
//  NewGameViewModel.swift
//  Brilliard
//
//  Created by Асан Мырзахметов on 11.08.2026.
//

import Foundation
import SwiftData

@Observable
final class NewGameViewModel {
    var pricePerHour: Decimal = 1000
    var tableCount: Int = 1
    var playerNames: [String] = [""]
    
    func addPlayerField() {
        playerNames.append("")
    }
    
    func removePlayer(at index: Int) {
        playerNames.remove(at: index)
    }
    
    var isValid: Bool {
            playerNames.filter { !$0.trimmingCharacters(in: .whitespaces).isEmpty }.count >= 2
        }
    
    func createGame(context: ModelContext) -> Game {
        let game = Game(pricePerHour: pricePerHour, tableCount: tableCount)
        for name in playerNames where !name.trimmingCharacters(in: .whitespaces).isEmpty {
            let player = Player(name: name)
            player.game = game
            game.roster.append(player)
        }
        context.insert(game)
        try? context.save()
        return game
    }
}
