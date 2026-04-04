import SwiftUI

struct GoalsView: View {
    @ObservedObject var viewModel: GreenStepsViewModel
    @State private var showAddGoalSheet = false
    @State private var showEditGoalSheet = false
    @State private var goalToEdit: EcoGoal?

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
                        Text("Goals")
                            .font(.headline)
                            .foregroundColor(.greenDark)
                            .padding(.horizontal)

                        LazyVStack(spacing: 12) {
                            ForEach(viewModel.goals) { goal in
                                GoalCard(goal: goal)
                                    .contentShape(Rectangle())
                                    .onTapGesture {
                                        goalToEdit = goal
                                        showEditGoalSheet = true
                                    }
                                    .swipeActions {
                                        Button(role: .destructive) {
                                            viewModel.deleteGoal(goal)
                                        } label: {
                                            Label("Delete", systemImage: "trash")
                                        }
                                    }
                            }

                            Button("Add goal") {
                                showAddGoalSheet = true
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
            .sheet(isPresented: $showAddGoalSheet) {
                AddGoalView(viewModel: viewModel)
            }
            .sheet(isPresented: $showEditGoalSheet) {
                if let goalToEdit {
                    EditGoalView(viewModel: viewModel, goal: goalToEdit)
                }
            }
        }
    }
}
