import SwiftUI

struct OnboardingView: View {
    @AppStorage("greensteps_hasCompletedOnboarding") private var hasCompletedOnboarding = false
    @State private var pageIndex = 0

    private let pages: [OnboardingPage] = [
        OnboardingPage(
            title: "Welcome",
            subtitle: "Build eco habits in minutes a day.",
            icon: "leaf.fill"
        ),
        OnboardingPage(
            title: "Track your actions",
            subtitle: "Log each eco activity and see your progress.",
            icon: "checkmark.circle.fill"
        ),
        OnboardingPage(
            title: "Reach your goals",
            subtitle: "Set goals, build streaks, and stay motivated.",
            icon: "target"
        )
    ]

    var body: some View {
        ZStack(alignment: .bottom) {
            Color.greenBackground.ignoresSafeArea()

            VStack(spacing: 18) {
                TabView(selection: $pageIndex) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        OnboardingPageView(page: pages[index])
                            .tag(index)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))

                pageIndicator
                    .padding(.bottom, 4)
            }

            controls
                .padding(.horizontal)
                .padding(.bottom, 26)
        }
        .accentColor(.greenSuccess)
    }

    private var pageIndicator: some View {
        HStack(spacing: 8) {
            ForEach(0..<pages.count, id: \.self) { index in
                Circle()
                    .fill(index == pageIndex ? Color.greenSuccess : Color.greenDark.opacity(0.25))
                    .frame(width: index == pageIndex ? 10 : 6, height: index == pageIndex ? 10 : 6)
                    .animation(.easeInOut(duration: 0.2), value: pageIndex)
            }
        }
    }

    private var controls: some View {
        VStack(spacing: 12) {
            HStack(spacing: 12) {
                if pageIndex > 0 {
                    Button("Back") {
                        pageIndex -= 1
                    }
                    .foregroundColor(.greenDark)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(
                        LinearGradient(
                            colors: [Color.white, Color.greenBackground.opacity(0.65)],
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
                } else {
                    Spacer()
                }

                Spacer()

                Button(pageIndex == pages.count - 1 ? "Get started" : "Next") {
                    if pageIndex == pages.count - 1 {
                        hasCompletedOnboarding = true
                    } else {
                        pageIndex += 1
                    }
                }
                .foregroundColor(.white)
                .padding(.horizontal, 18)
                .padding(.vertical, 12)
                .background(
                    LinearGradient(
                        colors: [Color.greenSuccess, Color.greenSuccess.opacity(0.65)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .cornerRadius(14)
                .shadow(color: Color.black.opacity(0.12), radius: 14, x: 0, y: 8)
            }
        }
    }
}

private struct OnboardingPage {
    let title: String
    let subtitle: String
    let icon: String
}

private struct OnboardingPageView: View {
    let page: OnboardingPage

    var body: some View {
        VStack(spacing: 18) {
            ZStack {
                Circle()
                    .fill(Color.greenDark.opacity(0.08))
                    .frame(width: 110, height: 110)

                Image(systemName: page.icon)
                    .font(.system(size: 44, weight: .bold))
                    .foregroundColor(.greenDark)
            }
            .padding(.top, 30)

            Text(page.title)
                .font(.largeTitle)
                .bold()
                .foregroundColor(.greenDark)

            Text(page.subtitle)
                .font(.body)
                .foregroundColor(.greenDark.opacity(0.85))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 26)

            Spacer()
        }
        .padding(.bottom, 10)
    }
}

