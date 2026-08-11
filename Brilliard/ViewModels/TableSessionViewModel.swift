//
//  TableSessionViewModel.swift
//  Brilliard
//
//  Created by Асан Мырзахметов on 11.08.2026.
//

import Foundation
import SwiftData

@Observable
final class TableSessionViewModel {
    var table: Table
    let timerEngine = TimerEngine()
    
    var pendingMode: GameMode = .oneVsOne
    var pendingTeamA: [Player] = []
    var pendingTeamB: [Player] = []
    
    var context: ModelContext
    
    init(table: Table, modelContext: ModelContext) {
        self.table = table
        self.context = modelContext
    }
    
    var isRoundReady: Bool {
        pendingTeamA.count == pendingMode.playersPerTeam &&
        pendingTeamB.count == pendingMode.playersPerTeam
    }
    
    func resetPending() {
            pendingTeamA = []
            pendingTeamB = []
            pendingMode = .oneVsOne
        }
    
    func startRound() {
        let round = Round(mode: pendingMode)
        
        round.startedAt = Date()
        round.teamA = pendingTeamA
        round.teamB = pendingTeamB
        round.table = table
        
        context.insert(round)
        table.rounds.append(round)
        timerEngine.start()
        
        Task { await save() }
    }
    
    func pauseRound() {
        timerEngine.pause()
    }
    
    @MainActor
    private func save() async {
        try? context.save()
    }
}
