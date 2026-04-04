import SwiftUI
import Charts

struct StatsView: View {
    @ObservedObject var viewModel: GreenStepsViewModel

    var body: some View {
        NavigationStack {
            ZStack {
                Color.greenBackground.ignoresSafeArea()

                LinearGradient(
                    colors: [Color.greenDark.opacity(0.12), Color.greenBackground.opacity(0.0)],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .frame(height: 260)
                .ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 12) {
                        Text("Statistics")
                            .font(.headline)
                            .foregroundColor(.greenDark)
                            .padding(.horizontal)

                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                            StatCard(title: "Total actions", value: "\(viewModel.totalActions)", icon: "checkmark.circle.fill", color: .greenSuccess, darkColor: .greenDark)
                            StatCard(title: "CO2 saved", value: String(format: "%.0f kg", viewModel.totalCO2Saved), icon: "cloud.fill", color: .greenSuccess, darkColor: .greenDark)
                            StatCard(title: "Water saved", value: String(format: "%.0f l", viewModel.totalWaterSaved), icon: "drop.fill", color: .greenSuccess, darkColor: .greenDark)
                            StatCard(title: "Less plastic", value: "\(viewModel.totalPlasticAvoided) pcs", icon: "trash.fill", color: .greenSuccess, darkColor: .greenDark)
                        }
                        .padding(.horizontal)

                        VStack(alignment: .leading) {
                            Text("Weekly activity")
                                .font(.headline)
                                .foregroundColor(.greenDark)

                            Chart {
                                ForEach(viewModel.weeklyActivity) { data in
                                    BarMark(x: .value("Day", data.day), y: .value("Actions", data.count))
                                        .foregroundStyle(Color.greenSuccess)
                                }
                            }
                            .frame(height: 150)
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
                        .padding(.horizontal)

                        VStack(alignment: .leading) {
                            Text("By category")
                                .font(.headline)
                                .foregroundColor(.greenDark)

                            ForEach(viewModel.categoryStats) { stat in
                                HStack {
                                    Text(stat.emoji).frame(width: 40)
                                    Text(stat.name).foregroundColor(.greenDark)
                                    Spacer()
                                    Text("\(stat.count)").foregroundColor(.greenSuccess).bold()
                                    Text("actions").foregroundColor(.gray).font(.caption)
                                }
                                .padding(.vertical, 4)
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
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.greenDark.opacity(0.08), lineWidth: 1)
                        )
                        .shadow(color: Color.black.opacity(0.10), radius: 14, x: 0, y: 6)
                        .padding(.horizontal)

                        if let bestDay = viewModel.bestDay {
                            VStack(alignment: .leading) {
                                Text("Best day")
                                    .font(.headline)
                                    .foregroundColor(.greenDark)

                                HStack {
                                    Text(formattedDate(bestDay.date))
                                        .foregroundColor(.greenDark)
                                    Spacer()
                                    Text("\(bestDay.actions) actions")
                                        .foregroundColor(.greenSuccess)
                                        .bold()
                                }
                                Text("Saved \(String(format: "%.0f", bestDay.impact)) units")
                                    .foregroundColor(.gray)
                                    .font(.caption)
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
                            .padding(.horizontal)
                        }
                    }
                    .padding(.vertical)
                }
            }
            .navigationBarHidden(true)
        }
    }
}
