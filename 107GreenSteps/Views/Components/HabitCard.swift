import SwiftUI

struct HabitCard: View {
    let habit: EcoHabit
    let onAdd: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(habit.category.emoji)
                    .font(.title2)

                Text(habit.name)
                    .font(.headline)
                    .foregroundColor(.greenDark)
                    .lineLimit(1)

                Spacer()

                if habit.isFavorite {
                    Image(systemName: "star.fill")
                        .foregroundColor(.greenSuccess)
                        .font(.caption)
                }
            }

            Text(habit.description)
                .font(.caption)
                .foregroundColor(.gray)
                .lineLimit(2)

            HStack {
                Image(systemName: "leaf.fill")
                    .font(.caption)
                    .foregroundColor(.greenSuccess)

                Text("\(habit.impactPerAction, specifier: "%.1f") \(habit.impactUnit.rawValue) each")
                    .font(.caption2)
                    .foregroundColor(.greenSuccess)

                Spacer()

                Button("+1", action: onAdd)
                    .font(.caption)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 4)
                    .background(
                        LinearGradient(
                            colors: [Color.greenSuccess, Color.greenSuccess.opacity(0.65)],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
        }
        .padding()
        .frame(width: 260)
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
