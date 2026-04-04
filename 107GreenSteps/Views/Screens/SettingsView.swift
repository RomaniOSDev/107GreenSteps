import SwiftUI
import StoreKit
import UIKit

struct SettingsView: View {
    var body: some View {
        NavigationStack {
            ZStack(alignment: .top) {
                Color.greenBackground.ignoresSafeArea()

                LinearGradient(
                    colors: [Color.greenDark.opacity(0.14), Color.greenBackground.opacity(0.0)],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .frame(height: 260)
                .ignoresSafeArea()

                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Settings")
                            .font(.largeTitle)
                            .bold()
                            .foregroundColor(.greenDark)
                            .padding(.horizontal)
                            .padding(.top, 12)

                        VStack(spacing: 12) {
                            SettingsButton(
                                icon: "star.fill",
                                title: "Rate us",
                                subtitle: "Leave a quick review"
                            ) {
                                rateApp()
                            }

                            SettingsButton(
                                icon: "shield.fill",
                                title: "Privacy",
                                subtitle: "Read our privacy policy"
                            ) {
                                openPolicy(AppLinks.url(for: .privacyPolicy))
                            }

                            SettingsButton(
                                icon: "doc.text.fill",
                                title: "Terms",
                                subtitle: "Read the terms of service"
                            ) {
                                openPolicy(AppLinks.url(for: .terms))
                            }
                        }
                        .padding(.horizontal)
                    }
                    .padding(.vertical)
                }
            }
            .navigationBarHidden(true)
        }
    }

    // MARK: - Actions
    private func openPolicy(_ url: URL?) {
        if let url = url {
            UIApplication.shared.open(url)
        }
    }

    private func rateApp() {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            SKStoreReviewController.requestReview(in: windowScene)
        }
    }
}

private struct SettingsButton: View {
    let icon: String
    let title: String
    let subtitle: String
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 14) {
                ZStack {
                    Circle()
                        .fill(Color.greenSuccess)
                        .opacity(0.18)
                    Image(systemName: icon)
                        .foregroundColor(.greenDark)
                        .font(.title3)
                }
                .frame(width: 44, height: 44)

                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.headline)
                        .foregroundColor(.greenDark)
                    Text(subtitle)
                        .font(.caption)
                        .foregroundColor(.gray)
                        .lineLimit(1)
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .foregroundColor(.greenDark.opacity(0.45))
            }
            .padding()
            .background(
                LinearGradient(
                    colors: [Color.white, Color.greenBackground.opacity(0.75)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .cornerRadius(14)
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(Color.greenDark.opacity(0.08), lineWidth: 1)
            )
            .shadow(color: Color.black.opacity(0.10), radius: 14, x: 0, y: 6)
        }
        .buttonStyle(.plain)
    }
}

