//
//  NewGameViewModel.swift
//  Brilliard
//
//  Created by Асан Мырзахметов on 11.08.2026.
//

import Foundation
import SwiftData
import Observation

@Observable
final class NewGameViewModel {
    var pricePerHour: Decimal = 1000
    var tableCount: Int = 1
    var players: [Player] = [Player(name:"")]
    
    func addPlayerField() {
        players.append(Player(name:""))
    }
    
    func removePlayer(at index: Int) {
        players.remove(at: index)
    }
    
    var isValid: Bool {
        players.filter { !$0.name.trimmingCharacters(in: .whitespaces).isEmpty }.count >= 2
        }
    
    func createGame(context: ModelContext) -> Game {
        let game = Game(pricePerHour: pricePerHour, tableCount: tableCount)
        for player in players where !player.name.trimmingCharacters(in: .whitespaces).isEmpty {
            player.game = game
            game.roster.append(player)
        }
        context.insert(game)
        try? context.save()
        return game
    }
}
