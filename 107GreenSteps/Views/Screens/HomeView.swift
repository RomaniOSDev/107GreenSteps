import SwiftUI

struct HomeView: View {
    @ObservedObject var viewModel: GreenStepsViewModel

    @State private var showAddAction = false
    @State private var actionToEdit: EcoAction?
    @State private var showEditActionSheet = false

    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottomTrailing) {
                Color.greenBackground.ignoresSafeArea()

                LinearGradient(
                    colors: [Color.greenDark.opacity(0.12), Color.greenBackground.opacity(0.0)],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .frame(height: 260)
                .ignoresSafeArea()

                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Eco habits")
                                .font(.largeTitle)
                                .bold()
                                .foregroundColor(.greenDark)

                            Text("Log your eco actions and track your progress.")
                                .foregroundColor(.greenDark.opacity(0.85))
                        }
                        .padding(.horizontal)

                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                StatCard(
                                    title: "Actions",
                                    value: "\(viewModel.totalActions)",
                                    icon: "checkmark.circle.fill",
                                    color: .greenSuccess,
                                    darkColor: .greenDark
                                )

                                StatCard(
                                    title: "CO2 saved",
                                    value: String(format: "%.0f kg", viewModel.totalCO2Saved),
                                    icon: "cloud.fill",
                                    color: .greenSuccess,
                                    darkColor: .greenDark
                                )

                                StatCard(
                                    title: "Water saved",
                                    value: String(format: "%.0f l", viewModel.totalWaterSaved),
                                    icon: "drop.fill",
                                    color: .greenSuccess,
                                    darkColor: .greenDark
                                )

                                StatCard(
                                    title: "Streak days",
                                    value: "\(viewModel.streakDays)",
                                    icon: "flame.fill",
                                    color: .greenSuccess,
                                    darkColor: .greenDark
                                )
                            }
                            .padding(.horizontal)
                        }

                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text("Today")
                                    .foregroundColor(.greenDark)
                                    .font(.headline)

                                Spacer()

                                Text("\(viewModel.todayActionsCount) actions")
                                    .foregroundColor(.greenSuccess)
                                    .font(.subheadline)
                            }

                            ProgressView(value: viewModel.todayProgress)
                                .tint(.greenSuccess)
                                .background(Color.greenDark.opacity(0.2))
                                .frame(height: 8)
                                .scaleEffect(y: 2)
                        }
                        .padding()
                        .background(
                            LinearGradient(
                                colors: [Color.white, Color.greenBackground.opacity(0.70)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.greenDark.opacity(0.08), lineWidth: 1)
                        )
                        .shadow(color: Color.black.opacity(0.10), radius: 14, x: 0, y: 6)
                        .padding(.horizontal)

                        VStack(alignment: .leading, spacing: 12) {
                            Text("Active habits")
                                .font(.headline)
                                .foregroundColor(.greenDark)

                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 12) {
                                    ForEach(viewModel.activeHabits) { habit in
                                        HabitCard(habit: habit) {
                                            logAction(for: habit)
                                        }
                                    }
                                }
                                .padding(.horizontal)
                            }
                        }

                        VStack(alignment: .leading, spacing: 12) {
                            Text("Recent actions")
                                .font(.headline)
                                .foregroundColor(.greenDark)

                            LazyVStack(spacing: 8) {
                                ForEach(viewModel.recentActions) { action in
                                    ActionRow(action: action)
                                        .contentShape(Rectangle())
                                        .onTapGesture {
                                            actionToEdit = action
                                            showEditActionSheet = true
                                        }
                                        .swipeActions {
                                            Button(role: .destructive) {
                                                viewModel.deleteAction(action)
                                            } label: {
                                                Label("Delete", systemImage: "trash")
                                            }
                                        }
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                    .padding(.vertical)
                }

                Button {
                    showAddAction = true
                } label: {
                    ZStack {
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [Color.greenSuccess, Color.greenSuccess.opacity(0.65)],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                        Image(systemName: "plus")
                            .foregroundColor(.white)
                            .font(.system(size: 22, weight: .bold))
                    }
                    .frame(width: 56, height: 56)
                    .overlay(
                        Circle().stroke(Color.white.opacity(0.30), lineWidth: 1)
                    )
                    .shadow(color: Color.black.opacity(0.12), radius: 14, x: 0, y: 8)
                }
                .padding()
            }
            .sheet(isPresented: $showAddAction) {
                AddActionView(viewModel: viewModel)
            }
            .sheet(isPresented: $showEditActionSheet) {
                if let actionToEdit {
                    EditActionView(viewModel: viewModel, action: actionToEdit)
                }
            }
            .navigationBarHidden(true)
        }
    }

    private func logAction(for habit: EcoHabit) {
        let action = EcoAction(
            id: UUID(),
            habitId: habit.id,
            habitName: habit.name,
            impactPerAction: habit.impactPerAction,
            impactUnit: habit.impactUnit,
            date: Date(),
            quantity: 1,
            notes: nil,
            location: nil
        )
        viewModel.addAction(action)
    }
}

