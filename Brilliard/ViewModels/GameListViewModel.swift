//
//  GameListViewModel.swift
//  Brilliard
//
//  Created by Асан Мырзахметов on 26.08.2026.
//

import SwiftUI
import SwiftData

@Observable
final class GameListViewModel {
    private(set) var activeGames: [Game] = []
    private(set) var finishedGames: [Game] = []
    private(set) var isLoading = false
    
    private var context: ModelContext?
    
    init() {}
    
    func configure(context: ModelContext) {
        guard self.context == nil else { return }
        self.context = context
        loadGames()
    }
    
    func loadGames() {
        guard let context else { return }
        isLoading = true
        defer { isLoading = false }
        
        var activeDescriptor = FetchDescriptor<Game>(
            predicate: #Predicate { $0.isActive },
            sortBy: [ SortDescriptor(\.createdAt, order: .reverse) ]
        )
        var finishedDescriptor = FetchDescriptor<Game>(
            predicate: #Predicate { !$0.isActive },
            sortBy: [ SortDescriptor(\.createdAt, order: .reverse) ]
        )
        
        activeDescriptor.fetchLimit = 50
        finishedDescriptor.fetchLimit = 100
        
        activeGames = (try? context.fetch(activeDescriptor)) ?? []
        finishedGames = (try? context.fetch(finishedDescriptor)) ?? []
    }
    
    func deleteGame(_ game: Game) {
        context?.delete(game)
        save()
        loadGames()
    }
    
    private func save() {
        try? context?.save()
    }
}
