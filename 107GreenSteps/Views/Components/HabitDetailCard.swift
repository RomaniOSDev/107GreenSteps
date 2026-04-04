import SwiftUI

struct HabitDetailCard: View {
    let habit: EcoHabit
    let actionsCount: Int

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(habit.category.emoji)
                        .font(.title2)

                    Text(habit.name)
                        .font(.headline)
                        .foregroundColor(.greenDark)

                    if habit.isActive {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.greenSuccess)
                            .font(.caption)
                    }
                }

                Text(habit.description)
                    .font(.caption)
                    .foregroundColor(.gray)

                HStack {
                    Image(systemName: "leaf.fill")
                        .font(.caption)
                        .foregroundColor(.greenSuccess)

                    Text("Saves \(habit.impactPerAction, specifier: "%.1f") \(habit.impactUnit.rawValue)")
                        .font(.caption2)
                        .foregroundColor(.greenSuccess)
                }
            }

            Spacer()

            VStack(alignment: .trailing) {
                Text("\(actionsCount)")
                    .font(.title2)
                    .foregroundColor(.greenSuccess)

                Text("actions")
                    .font(.caption2)
                    .foregroundColor(.gray)
            }
        }
        .padding()
        .background(
            LinearGradient(
                colors: [Color.white, Color.greenBackground.opacity(0.65)],
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
    }
}
