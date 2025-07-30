//
//  TabMenu.swift
//  PomodoroTimerApp
//
//  Created by Диас Рошанов on 01.05.2025.
//

import SwiftUI

struct TabMenu: View {
    
    init() {
        UITabBar.appearance().unselectedItemTintColor = UIColor.white
        }
    
    var body: some View {
        ZStack{
            TabView(){
                MainView()
                    .tabItem{
                        Label( "Main", systemImage: "house.fill")
                            
                    }
                SettingsView()
                    .tabItem {
                        Label("Settings", systemImage: "slider.horizontal.3")

                    }
                HistoryView()
                    .tabItem{
                        Label("History", systemImage: "document")
                    }
            }.tint(.accentColor)
        }
    }
}

#Preview {
    TabMenu().environmentObject(TimerSettings())
}
