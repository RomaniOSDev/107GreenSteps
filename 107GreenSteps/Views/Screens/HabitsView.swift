import SwiftUI

struct HabitsView: View {
    @ObservedObject var viewModel: GreenStepsViewModel
    @State private var showAddHabitSheet = false

    @State private var showEditHabitSheet = false
    @State private var habitToEdit: EcoHabit?

    var body: some View {
        NavigationStack {
            ZStack {
                Color.greenBackground.ignoresSafeArea()

                LinearGradient(
                    colors: [Color.greenDark.opacity(0.12), Color.greenBackground.opacity(0.0)],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .frame(height: 260)
                .ignoresSafeArea()

                ScrollView {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Habits")
                            .font(.headline)
                            .foregroundColor(.greenDark)
                            .padding(.horizontal)

                    LazyVStack(spacing: 12) {
                        ForEach(viewModel.allHabits) { habit in
                            HabitDetailCard(habit: habit, actionsCount: viewModel.actionsCount(for: habit.id))
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    habitToEdit = habit
                                    showEditHabitSheet = true
                                }
                                .swipeActions {
                                    Button(role: .destructive) {
                                        viewModel.deleteHabit(habit)
                                    } label: {
                                        Label("Delete", systemImage: "trash")
                                    }

                                    Button {
                                        viewModel.toggleActive(habit)
                                    } label: {
                                        Label(habit.isActive ? "Disable" : "Activate", systemImage: "power")
                                    }
                                    .tint(.greenSuccess)
                                }
                        }

                        Button("Add habit") {
                            showAddHabitSheet = true
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            LinearGradient(
                                colors: [Color.white, Color.greenBackground.opacity(0.75)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .foregroundColor(.greenSuccess)
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.greenDark.opacity(0.08), lineWidth: 1)
                        )
                        .shadow(color: Color.black.opacity(0.10), radius: 14, x: 0, y: 6)
                    }
                    .padding()
                    }
                }
            }
            .navigationBarHidden(true)
            .sheet(isPresented: $showAddHabitSheet) {
                AddHabitView(viewModel: viewModel)
            }
            .sheet(isPresented: $showEditHabitSheet) {
                if let habitToEdit {
                    EditHabitView(viewModel: viewModel, habit: habitToEdit)
                }
            }
        }
    }
}
