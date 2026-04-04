import SwiftUI

struct EditGoalView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: GreenStepsViewModel
    let goal: EcoGoal

    @State private var name: String
    @State private var targetValue: Double
    @State private var unit: ImpactUnit
    @State private var deadline: Date
    @State private var hasDeadline: Bool

    init(viewModel: GreenStepsViewModel, goal: EcoGoal) {
        self.viewModel = viewModel
        self.goal = goal
        _name = State(initialValue: goal.name)
        _targetValue = State(initialValue: goal.targetValue)
        _unit = State(initialValue: goal.unit)
        _deadline = State(initialValue: goal.deadline ?? Date())
        _hasDeadline = State(initialValue: goal.deadline != nil)
    }

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Goal name", text: $name)
                    TextField("Target", value: $targetValue, format: .number)
                        .keyboardType(.decimalPad)

                    Picker("Unit", selection: $unit) {
                        ForEach(ImpactUnit.allCases, id: \.self) { current in
                            Text(current.rawValue).tag(current)
                        }
                    }
                }

                Section {
                    Toggle("Set deadline", isOn: $hasDeadline)
                        .tint(.greenSuccess)

                    if hasDeadline {
                        DatePicker("Deadline", selection: $deadline, displayedComponents: .date)
                    }
                }
            }
            .scrollContentBackground(.hidden)
            .background(
                LinearGradient(
                    colors: [Color.greenBackground, Color.greenBackground.opacity(0.65)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .navigationTitle("Edit goal")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") { dismiss() }
                        .foregroundColor(.greenDark)
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save", action: save)
                        .disabled(name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                        .foregroundColor(.white)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(Color.greenSuccess)
                        .cornerRadius(10)
                }
            }
        }
    }

    private func save() {
        let updated = EcoGoal(
            id: goal.id,
            name: name.trimmingCharacters(in: .whitespacesAndNewlines),
            targetValue: max(targetValue, 1),
            currentValue: goal.currentValue,
            unit: unit,
            deadline: hasDeadline ? deadline : nil,
            isCompleted: goal.isCompleted,
            createdAt: goal.createdAt
        )
        viewModel.updateGoal(updated)
        dismiss()
    }
}

