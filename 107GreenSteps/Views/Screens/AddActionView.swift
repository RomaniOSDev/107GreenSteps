import SwiftUI

struct AddActionView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: GreenStepsViewModel
    let initialHabitId: UUID?

    @State private var selectedHabitId: UUID?
    @State private var quantity = 1
    @State private var date = Date()
    @State private var notes = ""
    @State private var location = ""

    private var selectedHabit: EcoHabit? {
        viewModel.activeHabits.first(where: { $0.id == selectedHabitId })
    }

    init(viewModel: GreenStepsViewModel, initialHabitId: UUID? = nil) {
        self._viewModel = ObservedObject(wrappedValue: viewModel)
        self.initialHabitId = initialHabitId
    }

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    Picker("Habit", selection: $selectedHabitId) {
                        Text("Select habit").tag(nil as UUID?)
                        ForEach(viewModel.activeHabits) { habit in
                            Text(habit.name).tag(habit.id as UUID?)
                        }
                    }
                    .tint(.greenSuccess)
                }

                Section("Quantity") {
                    HStack {
                        Button("-") { if quantity > 1 { quantity -= 1 } }
                            .frame(width: 40, height: 40)
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(8)

                        Text("\(quantity)")
                            .frame(width: 50)
                            .font(.title2)

                        Button("+") { quantity += 1 }
                            .frame(width: 40, height: 40)
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(8)

                        Spacer()

                        if let habit = selectedHabit {
                            Text("× \(habit.impactPerAction, specifier: "%.1f") \(habit.impactUnit.rawValue)")
                                .foregroundColor(.greenSuccess)
                        }
                    }
                }

                Section("Details") {
                    DatePicker("Date", selection: $date, displayedComponents: [.date, .hourAndMinute])
                    TextField("Notes", text: $notes)
                    TextField("Location", text: $location)
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
            .navigationTitle("New action")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") { dismiss() }
                        .foregroundColor(.greenDark)
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save", action: save)
                        .disabled(selectedHabit == nil)
                        .foregroundColor(.white)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(Color.greenSuccess)
                        .cornerRadius(10)
                }
            }
            .onAppear {
                if selectedHabitId == nil {
                    selectedHabitId = initialHabitId ?? viewModel.activeHabits.first?.id
                }
            }
        }
    }

    private func save() {
        guard let habit = selectedHabit else { return }

        let action = EcoAction(
            id: UUID(),
            habitId: habit.id,
            habitName: habit.name,
            impactPerAction: habit.impactPerAction,
            impactUnit: habit.impactUnit,
            date: date,
            quantity: quantity,
            notes: notes.isEmpty ? nil : notes,
            location: location.isEmpty ? nil : location
        )
        viewModel.addAction(action)
        dismiss()
    }
}
