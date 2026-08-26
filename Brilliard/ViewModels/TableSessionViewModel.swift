//
//  TableSessionViewModel.swift
//  Brilliard
//
//  Created by Асан Мырзахметов on 11.08.2026.
//

import Foundation
import SwiftData
import Observation

@Observable
final class TableSessionViewModel {
    var table: Table
    let timerEngine = TimerEngine()
    
    var pendingMode: GameMode = .oneVsOne
    var pendingTeamA: [Player] = []
    var pendingTeamB: [Player] = []
    
    var context: ModelContext
    
    init(table: Table, context: ModelContext) {
        self.table = table
        self.context = context
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
        guard isRoundReady else { return }
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
    
    func finishRound() {
        guard let round = table.activeRound else { return }
        _ = timerEngine.stop()
        round.endedAt = Date()
        resetPending()
        
        Task { await save() }
    }
    
    @MainActor
    private func save() async {
        try? context.save()
    }
}
