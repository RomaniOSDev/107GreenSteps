import SwiftUI

struct ActionRow: View {
    let action: EcoAction

    var body: some View {
        HStack {
            Image(systemName: "checkmark.circle.fill")
                .foregroundColor(.greenSuccess)
                .font(.title2)

            VStack(alignment: .leading) {
                Text(action.habitName)
                    .foregroundColor(.greenDark)
                    .font(.headline)

                Text(formattedDate(action.date))
                    .font(.caption)
                    .foregroundColor(.gray)
            }

            Spacer()

            VStack(alignment: .trailing) {
                Text("+\(action.quantity)")
                    .foregroundColor(.greenSuccess)
                    .font(.headline)

                Text("\(action.impactSaved, specifier: "%.1f") \(action.impactUnit.rawValue)")
                    .font(.caption2)
                    .foregroundColor(.greenSuccess)
            }
        }
        .padding()
        .background(
            LinearGradient(
                colors: [Color.white, Color.greenBackground.opacity(0.70)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.greenDark.opacity(0.06), lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.10), radius: 12, x: 0, y: 5)
    }
}
