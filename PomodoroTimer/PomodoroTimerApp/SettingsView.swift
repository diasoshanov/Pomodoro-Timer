//
//  SettingView.swift
//  PomodoroTimerApp
//
//  Created by Диас Рошанов on 01.05.2025.
//

import SwiftUI

struct SettingsView: View {
    
    @EnvironmentObject var timerSettings: TimerSettings
  
    var body: some View {
        ZStack{
            Color(.background).edgesIgnoringSafeArea(.all)
            VStack {
                Text("Settings")
                    .font(.system(size: 17, weight: .bold, design: .default))
                    .foregroundStyle(Color.white)
                Spacer()
                VStack(spacing:10){
                    HStack{
                        DatePicker("Focus time", selection: $timerSettings.focusTime, displayedComponents: .hourAndMinute)
                            .colorInvert()
                            .colorMultiply(Color.white)
                    }.padding(.horizontal)
                    Divider()
                    HStack{
                        DatePicker("Break Time", selection: $timerSettings.breakTime, displayedComponents: .hourAndMinute)
                            .colorInvert()
                            .colorMultiply(Color.white)
                    }.padding(.horizontal)
                    Spacer()
                }.padding(.top,24)
            }
           
        }
    }
}

#Preview {
    SettingsView().environmentObject(TimerSettings())
}
