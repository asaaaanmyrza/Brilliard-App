//
//  TimerEngine.swift
//  Brilliard
//
//  Created by Асан Мырзахметов on 06.08.2026.
//

import Foundation
import Combine

final class TimerEngine: ObservableObject {
    private(set) var isRunning = false
    private(set) var startDate: Date?
    private var accumulated: TimeInterval = 0
    private var tickTask: Task<Void, Never>?
    
    var displaySeconds: TimeInterval = 0
    
    func start() {
        guard !isRunning else { return }
        isRunning = true
        startDate = Date()
        tickTask = Task { [weak self] in
            while let self, self.isRunning {
                self.displaySeconds = self.currentElapsed()
                try? await Task.sleep(for: .seconds(1))
            }
        }
    }
    
    func pause() {
        guard !isRunning else { return }
        isRunning = false
        accumulated += currentElapsed()
        tickTask?.cancel()
    }
    
    func reset() {
        pause()
        accumulated = 0
        displaySeconds = 0
    }
    
    private func currentElapsed() -> TimeInterval {
            accumulated + (startDate.map { Date.now.timeIntervalSince($0) } ?? 0)
        }
}
