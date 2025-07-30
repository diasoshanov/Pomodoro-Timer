//
//  PomodoroTimerAppApp.swift
//  PomodoroTimerApp
//
//  Created by Диас Рошанов on 01.05.2025.
//

import SwiftUI

@main
struct PomodoroTimerAppApp: App {
    @StateObject var timerSettings = TimerSettings()
    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(timerSettings)
        }
    }
}
