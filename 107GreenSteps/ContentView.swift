//
//  ContentView.swift
//  107GreenSteps
//
//  Created by Роман Главацкий on 25.03.2026.
//

import SwiftUI
import UserNotifications

struct ContentView: View {
    @StateObject private var viewModel = GreenStepsViewModel()
    @State private var selectedTab = 0
    @AppStorage("greensteps_hasCompletedOnboarding") private var hasCompletedOnboarding = false

    var body: some View {
        Group {
            if hasCompletedOnboarding {
                TabView(selection: $selectedTab) {
                    HomeView(viewModel: viewModel)
                        .tabItem {
                            Label("Home", systemImage: "leaf.fill")
                        }
                        .tag(0)

                    HabitsView(viewModel: viewModel)
                        .tabItem {
                            Label("Habits", systemImage: "list.bullet")
                        }
                        .tag(1)

                    GoalsView(viewModel: viewModel)
                        .tabItem {
                            Label("Goals", systemImage: "target")
                        }
                        .tag(2)

                    StatsView(viewModel: viewModel)
                        .tabItem {
                            Label("Stats", systemImage: "chart.bar.fill")
                        }
                        .tag(3)

                    SettingsView()
                        .tabItem {
                            Label("Settings", systemImage: "gearshape.fill")
                        }
                        .tag(4)
                }
            } else {
                OnboardingView()
            }
        }
        .tint(.greenSuccess)
        .onAppear {
            viewModel.loadFromUserDefaults()
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { _, _ in }
        }
    }
}

#Preview {
    ContentView()
}
