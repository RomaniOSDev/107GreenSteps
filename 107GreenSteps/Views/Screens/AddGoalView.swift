import SwiftUI

struct AddGoalView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: GreenStepsViewModel

    @State private var name = ""
    @State private var targetValue = 10.0
    @State private var unit: ImpactUnit = .kg
    @State private var deadline = Date()
    @State private var hasDeadline = false

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
            .navigationTitle("New goal")
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
        let goal = EcoGoal(
            id: UUID(),
            name: name.trimmingCharacters(in: .whitespacesAndNewlines),
            targetValue: max(targetValue, 1),
            currentValue: 0,
            unit: unit,
            deadline: hasDeadline ? deadline : nil,
            isCompleted: false,
            createdAt: Date()
        )
        viewModel.addGoal(goal)
        dismiss()
    }
}
