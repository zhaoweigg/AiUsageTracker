import Foundation

enum AiProvider: String, CaseIterable, Identifiable, Codable, Sendable {
    case claude

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .claude: "Claude"
        }
    }

    var systemImage: String {
        switch self {
        case .claude: "brain.head.profile"
        }
    }
}
