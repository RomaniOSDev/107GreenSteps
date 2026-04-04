import SwiftUI

struct DashboardView: View {
    @ObservedObject var viewModel: GreenStepsViewModel
    @State private var showAddAction = false
    @State private var initialHabitId: UUID?
    @State private var showEditActionSheet = false
    @State private var actionToEdit: EcoAction?

    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottomTrailing) {
                Color.greenBackground.ignoresSafeArea()

                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Hello!")
                            .font(.largeTitle)
                            .bold()
                            .foregroundColor(.greenDark)
                            .padding(.horizontal)

                        Text("Track today and keep your eco streak.")
                            .foregroundColor(.greenDark.opacity(0.8))
                            .padding(.horizontal)

                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                StatCard(title: "Actions", value: "\(viewModel.totalActions)", icon: "checkmark.circle.fill", color: .greenSuccess, darkColor: .greenDark)
                                StatCard(title: "CO2 saved", value: String(format: "%.0f kg", viewModel.totalCO2Saved), icon: "cloud.fill", color: .greenSuccess, darkColor: .greenDark)
                                StatCard(title: "Water saved", value: String(format: "%.0f l", viewModel.totalWaterSaved), icon: "drop.fill", color: .greenSuccess, darkColor: .greenDark)
                                StatCard(title: "Streak days", value: "\(viewModel.streakDays)", icon: "flame.fill", color: .greenSuccess, darkColor: .greenDark)
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
                        .background(Color.white)
                        .cornerRadius(12)
                        .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
                        .padding(.horizontal)

                        VStack(alignment: .leading) {
                            Text("Active habits")
                                .font(.headline)
                                .foregroundColor(.greenDark)
                                .padding(.horizontal)

                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 12) {
                                    ForEach(viewModel.activeHabits) { habit in
                                        HabitCard(habit: habit) {
                                            initialHabitId = habit.id
                                            showAddAction = true
                                        }
                                    }
                                }
                                .padding(.horizontal)
                            }
                        }

                        VStack(alignment: .leading) {
                            Text("Recent actions")
                                .font(.headline)
                                .foregroundColor(.greenDark)
                                .padding(.horizontal)

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
                    initialHabitId = nil
                    showAddAction = true
                } label: {
                    ZStack {
                        Circle()
                            .fill(Color.greenSuccess)
                        Image(systemName: "plus")
                            .foregroundColor(.white)
                            .font(.system(size: 22, weight: .bold))
                    }
                    .frame(width: 56, height: 56)
                    .shadow(color: Color.black.opacity(0.1), radius: 6, x: 0, y: 2)
                }
            }
            .sheet(isPresented: $showAddAction) {
                AddActionView(viewModel: viewModel, initialHabitId: initialHabitId)
            }
            .sheet(isPresented: $showEditActionSheet) {
                if let actionToEdit {
                    EditActionView(viewModel: viewModel, action: actionToEdit)
                }
            }
            .navigationBarHidden(true)
        }
    }
}
