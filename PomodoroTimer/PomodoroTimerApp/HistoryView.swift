//
//  HistoryView.swift
//  PomodoroTimerApp
//
//  Created by Диас Рошанов on 01.05.2025.
//

import SwiftUI

struct HistoryView: View {
    
    @EnvironmentObject var timerSettings: TimerSettings

    var body: some View{
        ZStack {
            VStack {
                Text("History")
                    .font(.system(size: 17, weight: .bold, design: .default))
                    .foregroundStyle(Color.white)
                List {
                    ForEach(timerSettings.history.reversed()) { session in
                        HistoryRowView(session: session)
                            .listRowInsets(EdgeInsets())
                    }
                }
                .listStyle(PlainListStyle())

            }
        }.background(Color.background)
    }
}

#Preview {
    HistoryView().environmentObject(TimerSettings())
}
