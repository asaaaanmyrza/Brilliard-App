//
//  Table.swift
//  Brilliard
//
//  Created by Асан Мырзахметов on 06.08.2026.
//

import Foundation
import SwiftData

@Model
final class Table {
    @Attribute(.unique) var id: UUID
    var number: Int
    var game: Game?
    
    @Relationship(deleteRule: .cascade, inverse: \Round.table)
    var rounds: [Round] = []
    
    var activeRound: Round? {
        rounds.first { $0.startedAt != nil && $0.endedAt == nil }
    }
    
    init(number: Int) {
        self.id = UUID()
        self.number = number
    }
}
