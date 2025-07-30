//
//  ContentView.swift
//  PomodoroTimerApp
//
//  Created by Диас Рошанов on 01.05.2025.
//

import SwiftUI

struct MainView: View {
    @EnvironmentObject var timerSettings: TimerSettings
    @State var isPresented: Bool = false
    @State private var selectedCategory: FocusCategory?

    var body: some View {
        ZStack{
            Image(selectedCategory?.backgroundName ?? "reading")
                .resizable()
                .edgesIgnoringSafeArea(.all)
                .scaledToFill()
            VStack{
                focusCat(isPresented: $isPresented)
                    .sheet(isPresented: $isPresented){
                        BottomSheet(isPresented: $isPresented, selectedCategory: $selectedCategory)
                            .presentationCornerRadius(20)
                            .presentationDetents([.height(304)])
                    }
                    .padding(.bottom,52)
                ZStack{
                    time()
                    ProgressCircleView(progress: progressValue)
                }
                
                ButtonsView()
                    .environmentObject(timerSettings)
                    .padding(.vertical,50)
                
            }
            
        }
    }
    
    var progressValue: Double {
        let totalSeconds = Calendar.current.component(.hour, from: timerSettings.focusTime) * 3600 +
                           Calendar.current.component(.minute, from: timerSettings.focusTime) * 60
        guard totalSeconds > 0 else { return 0.0 }
        return 1.0 - Double(timerSettings.remainingSeconds) / Double(totalSeconds)
    }

}
    
    struct BottomSheet:  View {
        @Binding var isPresented: Bool
        @Binding var selectedCategory: FocusCategory?
        
        private let columns = [
            GridItem(.flexible()),
            GridItem(.flexible())
        ]
        
        var body: some View{
            VStack {
                Spacer()
                ZStack{
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.white)
                        .frame(height: 362)
                    VStack{
                        HStack{
                            Spacer()
                            Text("Focus Category")
                                .font(.system(size: 16))
                                .fixedSize()
                                .frame(width: 110,height: 24)
                                .padding(.trailing,100)
                            Button{isPresented = false} label: {
                                Image(systemName: "xmark")
                                    .foregroundStyle(Color.black)
                                    .padding(16)
                            }.frame(width: 24,height: 24)
                                .padding(.trailing,16)
                        }.padding(.bottom,24)
                        
                        LazyVGrid(columns: columns, spacing: 20){
                            ForEach(FocusCategory.allCases){ category in
                                Button(action: {
                                    selectedCategory = category
                                })
                                {Text(category.rawValue)
                                        .font(.system(size: 16, weight: .medium))
                                        .frame(maxWidth: 172, minHeight: 60)
                                        .background(
                                            RoundedRectangle(cornerRadius: 15)
                                                .fill(selectedCategory == category ? Color.black : Color(UIColor.systemGray6))
                                        )
                                        .foregroundColor(selectedCategory == category ? .white : .background)
                                }
                                
                            }
                        }.padding(.horizontal)
                    }
                }
                
            }
        }
    }
    
    struct focusCat:  View{
        @Binding var isPresented: Bool
        
        var body: some View{
            ZStack{
                Button(action: {isPresented = true}){
                    HStack(spacing:8){
                        Image(systemName: "pencil")
                            .foregroundStyle(Color.white)
                        Text("Focus Category")
                            .font(.system(size: 16).bold())
                            .foregroundStyle(Color.white)
                    }
                }.frame(width: 170, height: 36, alignment: .center)
                    .background(Color.white.opacity(0.2))
                    .cornerRadius(24)
                
            }
        }
    }
    
    struct time: View{
        
        @EnvironmentObject var timerSettings: TimerSettings
        
        var body: some View{
            ZStack{
                VStack {
                    Text((timerSettings.isRunning || timerSettings.isPaused)
                         ? timerSettings.formattedTime
                         : timerSettings.focusTime.formatted(date: .omitted, time: .shortened))
                        .foregroundStyle(Color.white)
                        .font(.system(size: 44, weight: .bold, design: .default))
                    Text(timerSettings.mode == .focus ? "Focus on your task" :"Break")
                        .foregroundStyle(Color.white)
                        .font(.system(size: 16, weight: .medium, design: .default))
                }
                Circle()
                    .stroke(lineWidth: 6)
                    .foregroundStyle(Color.white.opacity(0.2))
                    .frame(width: 248, height: 264)
            }
        }
    }
    
    struct ProgressCircleView: View {
    var progress: Double
    @EnvironmentObject var timerSettings: TimerSettings
    var body: some View {
        if timerSettings.isRunning || timerSettings.isPaused {
            Circle()
                .trim(from: 0.0, to: progress)
                .stroke(Color.white, lineWidth: 6)
                .frame(width: 248, height: 264)
                .rotationEffect(.degrees(-90))
                .animation(.linear(duration: 1), value: progress)
        }else{
            Circle()
                .trim(from: 0, to: 0)
                .stroke(Color.white, lineWidth: 6)
                .frame(width: 248, height: 264)
                .rotationEffect(.degrees(-90))
                .animation(.linear(duration: 1), value: progress)
        }
    }
    
    
}

    struct ButtonsView: View{
    @EnvironmentObject var timerSettings: TimerSettings
    var body: some View{
        HStack(spacing: 80) {
            Button(action: {
                if timerSettings.isRunning {
                    timerSettings.pauseTimer()
                } else {
                    timerSettings.startTimer()
                }
            }) {
                ZStack {
                    Circle()
                        .frame(width: 56, height: 56)
                        .foregroundStyle(Color.gray)
                    Image(systemName: timerSettings.isRunning ? "pause.fill" : "play.fill")
                        .foregroundStyle(Color.white)
                }
            }

            Button(action: {
                timerSettings.stopTimer()
            }) {
                ZStack {
                    Circle()
                        .frame(width: 56, height: 56)
                        .foregroundStyle(Color.gray)
                    Image(systemName: "stop.fill")
                        .foregroundStyle(Color.white)
                }
            }
        }

    }
}
   
#Preview {
        MainView().environmentObject(TimerSettings())
}
