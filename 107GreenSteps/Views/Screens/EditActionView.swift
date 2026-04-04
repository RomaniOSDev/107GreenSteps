import SwiftUI

struct EditActionView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: GreenStepsViewModel
    let action: EcoAction

    @State private var quantity: Int
    @State private var date: Date
    @State private var notes: String
    @State private var location: String

    init(viewModel: GreenStepsViewModel, action: EcoAction) {
        self.viewModel = viewModel
        self.action = action
        _quantity = State(initialValue: action.quantity)
        _date = State(initialValue: action.date)
        _notes = State(initialValue: action.notes ?? "")
        _location = State(initialValue: action.location ?? "")
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Habit") {
                    Text(action.habitName)
                        .foregroundColor(.greenDark)
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

                        Text("Impact: \(Double(quantity) * action.impactPerAction, specifier: "%.1f") \(action.impactUnit.rawValue)")
                            .foregroundColor(.greenSuccess)
                            .font(.caption)
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
            .navigationTitle("Edit action")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") { dismiss() }
                        .foregroundColor(.greenDark)
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save", action: save)
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
        let updated = EcoAction(
            id: action.id,
            habitId: action.habitId,
            habitName: action.habitName,
            impactPerAction: action.impactPerAction,
            impactUnit: action.impactUnit,
            date: date,
            quantity: max(quantity, 1),
            notes: notes.isEmpty ? nil : notes,
            location: location.isEmpty ? nil : location
        )
        viewModel.updateAction(updated)
        dismiss()
    }
}

