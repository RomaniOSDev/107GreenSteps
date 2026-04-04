import SwiftUI

struct EditHabitView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: GreenStepsViewModel
    let habit: EcoHabit

    @State private var name: String
    @State private var category: HabitCategory
    @State private var habitDescription: String
    @State private var impactPerAction: Double
    @State private var impactUnit: ImpactUnit
    @State private var dailyGoal: Int
    @State private var reminderTime: Date?
    @State private var isActive: Bool
    @State private var isFavorite: Bool

    init(viewModel: GreenStepsViewModel, habit: EcoHabit) {
        self.viewModel = viewModel
        self.habit = habit
        _name = State(initialValue: habit.name)
        _category = State(initialValue: habit.category)
        _habitDescription = State(initialValue: habit.description)
        _impactPerAction = State(initialValue: habit.impactPerAction)
        _impactUnit = State(initialValue: habit.impactUnit)
        _dailyGoal = State(initialValue: habit.dailyGoal)
        _reminderTime = State(initialValue: habit.reminderTime)
        _isActive = State(initialValue: habit.isActive)
        _isFavorite = State(initialValue: habit.isFavorite)
    }

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Name", text: $name)

                    Picker("Category", selection: $category) {
                        ForEach(HabitCategory.allCases, id: \.self) { cat in
                            Text("\(cat.emoji) \(cat.rawValue)").tag(cat)
                        }
                    }
                    .tint(.greenSuccess)

                    TextEditor(text: $habitDescription)
                        .frame(height: 80)
                }

                Section("Eco impact") {
                    HStack {
                        Text("Savings")
                        Spacer()
                        TextField("", value: $impactPerAction, format: .number)
                            .keyboardType(.decimalPad)
                            .frame(width: 80)
                            .multilineTextAlignment(.trailing)

                        Picker("", selection: $impactUnit) {
                            ForEach(ImpactUnit.allCases, id: \.self) { unit in
                                Text(unit.rawValue).tag(unit)
                            }
                        }
                        .pickerStyle(.menu)
                        .frame(width: 110)
                    }
                }

                Section("Goal") {
                    Stepper("Daily goal: \(dailyGoal)", value: $dailyGoal, in: 1...20)
                        .tint(.greenSuccess)

                    DatePicker("Reminder time", selection: Binding(get: {
                        reminderTime ?? Date()
                    }, set: { reminderTime = $0 }), displayedComponents: .hourAndMinute)
                        .tint(.greenSuccess)
                }

                Section {
                    Toggle("Activate now", isOn: $isActive)
                        .tint(.greenSuccess)
                    Toggle("Add to favorites", isOn: $isFavorite)
                        .tint(.greenSuccess)
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
            .navigationTitle("Edit habit")
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
        let updated = EcoHabit(
            id: habit.id,
            name: name.trimmingCharacters(in: .whitespacesAndNewlines),
            category: category,
            description: habitDescription.trimmingCharacters(in: .whitespacesAndNewlines),
            impactPerAction: max(impactPerAction, 0.1),
            impactUnit: impactUnit,
            isActive: isActive,
            dailyGoal: dailyGoal,
            reminderTime: reminderTime,
            isFavorite: isFavorite,
            createdAt: habit.createdAt
        )
        viewModel.updateHabit(updated)
        dismiss()
    }
}

