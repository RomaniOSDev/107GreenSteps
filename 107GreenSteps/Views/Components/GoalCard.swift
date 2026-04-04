import SwiftUI

struct GoalCard: View {
    let goal: EcoGoal

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(goal.name)
                    .font(.headline)
                    .foregroundColor(.greenDark)

                Spacer()

                if goal.isCompleted {
                    Text("Done")
                        .font(.caption)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(
                            LinearGradient(
                                colors: [Color.greenSuccess.opacity(0.25), Color.greenSuccess.opacity(0.10)],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .foregroundColor(.greenSuccess)
                        .cornerRadius(8)
                } else if let deadline = goal.deadline {
                    Text("By \(formattedShortDate(deadline))")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }

            HStack {
                Text("\(goal.currentValue, specifier: "%.1f") / \(goal.targetValue, specifier: "%.1f")")
                    .font(.title2)
                    .foregroundColor(goal.isCompleted ? .greenSuccess : .greenDark)

                Text(goal.unit.rawValue)
                    .font(.caption)
                    .foregroundColor(.gray)
            }

            ProgressView(value: goal.progress)
                .tint(.greenSuccess)
                .background(Color.greenDark.opacity(0.15))
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .frame(height: 8)
                .scaleEffect(y: 1.5)
        }
        .padding()
        .background(
            LinearGradient(
                colors: [Color.white, Color.greenBackground.opacity(0.70)],
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
