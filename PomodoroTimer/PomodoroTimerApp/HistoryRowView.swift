//
//  HistoryRowView.swift
//  PomodoroTimerApp
//
//  Created by Диас Рошанов on 03.05.2025.
//

import Foundation
import SwiftUI

struct HistoryRowView: View {
    @EnvironmentObject var timerSettings: TimerSettings
    let session: Session
    
    var body: some View {
        VStack{
            HStack {
                Text("\(session.date.formatted(date: .numeric, time:.omitted))")
                    .font(.title2)
                    .foregroundColor(.white)
                Spacer()
            }.padding()
            HStack{
                Text(session.mode == .focus ? "Focus Time" : "Break Time")
                    .font(.system(size: 17))
                    .foregroundColor(.white)
                Spacer()
                Text("\(session.duration / 60) мин")
                    .font(.system(size: 17))
                    .foregroundStyle(Color.gray)
            }.padding()
            HStack{
                Text(session.mode == .breakTime ? "Break Time" : "Break Time")
                    .font(.system(size: 17))
                    .foregroundColor(.white)
                Spacer()
                Text("\(session.duration / 60) мин")
                    .font(.system(size: 17))
                    .foregroundStyle(Color.gray)
            }.padding()
        }.background(Color.background)
    }
}

#Preview {
    HistoryRowView( session: Session(id: UUID(), category: .work, mode: .focus, duration: 25 * 60, date: Date())).environmentObject(TimerSettings())
    }


