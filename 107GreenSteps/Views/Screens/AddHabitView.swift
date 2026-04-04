import SwiftUI

struct AddHabitView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: GreenStepsViewModel

    @State private var name = ""
    @State private var category: HabitCategory = .other
    @State private var description = ""
    @State private var impactPerAction = 1.0
    @State private var impactUnit: ImpactUnit = .kg
    @State private var dailyGoal = 1
    @State private var reminderTime = Date()
    @State private var isActive = true
    @State private var isFavorite = false

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

                    TextEditor(text: $description)
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
                    DatePicker("Reminder time", selection: $reminderTime, displayedComponents: .hourAndMinute)
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
            .navigationTitle("New habit")
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
        let habit = EcoHabit(
            id: UUID(),
            name: name.trimmingCharacters(in: .whitespacesAndNewlines),
            category: category,
            description: description.trimmingCharacters(in: .whitespacesAndNewlines),
            impactPerAction: max(impactPerAction, 0.1),
            impactUnit: impactUnit,
            isActive: isActive,
            dailyGoal: dailyGoal,
            reminderTime: reminderTime,
            isFavorite: isFavorite,
            createdAt: Date()
        )
        viewModel.addHabit(habit)
        dismiss()
    }
}
