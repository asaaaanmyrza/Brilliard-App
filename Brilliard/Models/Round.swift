//
//  Round.swift
//  Brilliard
//
//  Created by Асан Мырзахметов on 06.08.2026.
//

import Foundation
import SwiftData

enum GameMode: String, Codable, CaseIterable {
    case oneVsOne = "1×1"
    case twoVsTwo = "2×2"

    var playersPerTeam: Int {
        switch self {
        case .oneVsOne: return 1
        case .twoVsTwo: return 2
        }
    }

    var totalPlayers: Int { playersPerTeam * 2 }
}

@Model
final class Round {
    @Attribute(.unique) var id: UUID
    var startedAt: Date?
    var endedAt: Date?
    var table: Table?
    var mode: GameMode
    
    @Relationship var teamA: [Player] = []
    @Relationship var teamB: [Player] = []
    
    var participants: [Player] { teamA + teamB }
    
    var duration: TimeInterval {
        guard let start = startedAt, let end = endedAt else { return 0 }
        return end.timeIntervalSince(start)
    }
    
    init(mode: GameMode) {
        self.id = UUID()
        self.mode = mode
    }
}
