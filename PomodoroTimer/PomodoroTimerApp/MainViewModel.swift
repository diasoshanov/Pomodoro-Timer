//
//  MainViewModel.swift
//  PomodoroTimerApp
//
//  Created by Диас Рошанов on 01.05.2025.
//

import Foundation

enum FocusCategory: String, CaseIterable, Identifiable, Codable{
    case work = "Work"
    case study = "Study"
    case workout = "Workout"
    case reading = "Reading"
    case meditation = "Meditation"
    case others = "Others"
    
    var id: String { rawValue }
}

enum Mode: Codable{
    case focus
    case breakTime
}

struct Session: Identifiable, Codable {
    var id = UUID()
    let category: FocusCategory
    let mode: Mode
    let duration: Int
    let date: Date
    
    
    
}


extension FocusCategory {
    var backgroundName: String {
        switch self {
        case .work: return "work"
        case .study: return "study"
        case .workout: return "workout"
        case .reading: return "reading"
        case .meditation: return "meditation"
        case .others: return "others"
        }
    }
}


class TimerSettings: ObservableObject {
    @Published var focusTime: Date = Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: Date()) ?? Date()
    @Published var breakTime: Date = Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: Date()) ?? Date()
    @Published var history: [Session] = []
    @Published var remainingSeconds: Int = 0
    @Published var isRunning = false
    @Published var isPaused = false
    @Published var mode: Mode = .focus

    private var timer: Timer?

    func startTimer() {
        if isPaused {
            isPaused = false
            isRunning = true
            runTimer()
        } else {
            isRunning = true
            isPaused = false
            setInitialTime(for: mode)
            runTimer()
        }
    }

    func pauseTimer() {
        timer?.invalidate()
        isRunning = false
        isPaused = true
    }

    func stopTimer() {
        timer?.invalidate()
        isRunning = false
        isPaused = false
        remainingSeconds = 0
        mode = .focus
    }

    private func setInitialTime(for mode: Mode) {
        let sourceTime = (mode == .focus) ? focusTime : breakTime
        let hours = Calendar.current.component(.hour, from: sourceTime)
        let minutes = Calendar.current.component(.minute, from: sourceTime)
        remainingSeconds = hours * 3600 + minutes * 60
    }

    private func runTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            if self.remainingSeconds > 0 {
                self.remainingSeconds -= 1
            } else {
                self.timer?.invalidate()
                self.isRunning = false
                self.switchModeAndRestart()
            }
        }
    }

    var formattedTime: String {
        let minutes = remainingSeconds / 60
        let seconds = remainingSeconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    private func switchModeAndRestart() {
        let totalDuration = (mode == .focus) ?
            Calendar.current.component(.hour, from: focusTime) * 3600 +
            Calendar.current.component(.minute, from: focusTime) * 60 :
            Calendar.current.component(.hour, from: breakTime) * 3600 +
            Calendar.current.component(.minute, from: breakTime) * 60

        let session = Session(
            category: .work,
            mode: mode,
            duration: totalDuration,
            date: Date()
        )

        history.append(session)

      
        mode = (mode == .focus) ? .breakTime : .focus
        startTimer()
    }
    
    func saveHistory() {
        if let data = try? JSONEncoder().encode(history) {
            UserDefaults.standard.set(data, forKey: "pomodoroHistory")
        }
    }

    func loadHistory() {
        if let data = UserDefaults.standard.data(forKey: "pomodoroHistory"),
           let sessions = try? JSONDecoder().decode([Session].self, from: data) {
            history = sessions
        }
    }


}


