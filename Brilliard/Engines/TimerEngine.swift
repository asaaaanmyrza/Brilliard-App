//
//  TimerEngine.swift
//  Brilliard
//
//  Created by Асан Мырзахметов on 06.08.2026.
//

import Foundation

@Observable
final class TimerEngine {
    private(set) var isRunning = false
    private var startDate: Date?
    private var tickTask: Task<Void, Never>?
    
    var displaySeconds: TimeInterval = 0
    
    func start() {
        guard !isRunning else { return }
        isRunning = true
        startDate = Date()
        tickTask = Task { [weak self] in
            while let self, self.isRunning {
                if let start = self.startDate {
                    self.displaySeconds = Date().timeIntervalSince(start)
                }
                try? await Task.sleep(for: .seconds(1))
            }
        }
    }
    
    @discardableResult
    func stop() -> TimeInterval {
        isRunning = false
        tickTask?.cancel()
        let elapsed = displaySeconds
        startDate = nil
        return elapsed
    }
}
