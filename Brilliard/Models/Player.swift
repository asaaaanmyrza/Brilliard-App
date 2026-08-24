//
//  Player.swift
//  Brilliard
//
//  Created by Асан Мырзахметов on 06.08.2026.
//

import Foundation
import SwiftData

@Model
final class Player {
    @Attribute(.unique) var id: UUID
    var game: Game?
    var name: String
    
    init(name: String) {
        self.id = UUID()
        self.name = name
    }
}

extension Player {
    var totalSeconds: TimeInterval {
        game?.tables
            .flatMap(\.rounds)
            .filter { $0.participants.contains(self) }
            .reduce(0) { $0 + $1.duration } ?? 0
    }
}
