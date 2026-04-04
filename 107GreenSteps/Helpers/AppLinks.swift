import Foundation

enum AppLinks {
    enum Policy: String {
        case privacyPolicy = "https://www.termsfeed.com/live/ed58cded-dd45-4bc3-928e-6a5b2106ea04"
        case terms = "https://www.termsfeed.com/live/61485225-b57f-4d8f-8977-5f20af5a2f93"
    }

    static func url(for link: Policy) -> URL? {
        URL(string: link.rawValue)
    }
}

