//
//  Game.swift
//  Brilliard
//
//  Created by Асан Мырзахметов on 06.08.2026.
//

import Foundation
import SwiftData

@Model
final class Game {
    @Attribute(.unique) var id: UUID
    var createdAt: Date
    var finishedAt: Date?
    var pricePerHour: Decimal
    var isActive: Bool
    
    @Relationship(deleteRule: .cascade, inverse: \Player.game)
    var roster: [Player] = []
    
    @Relationship(deleteRule: .cascade, inverse: \Table.game)
    var tables: [Table] = []
    
    var rentedSeconds: TimeInterval {
        let end = finishedAt ?? Date()
        return end.timeIntervalSince(createdAt)
    }
    
    init(pricePerHour: Decimal, tableCount: Int) {
        self.id = UUID()
        self.createdAt = Date()
        self.pricePerHour = pricePerHour
        self.isActive = true
        self.tables = (1...tableCount).map { Table(number: $0) }
    }
}
