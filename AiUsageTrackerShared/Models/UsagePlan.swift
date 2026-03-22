import Foundation

struct UsagePlan: Codable, Sendable {
    var provider: AiProvider
    var tierName: String
    var tokenLimit: Int
    var resetIntervalHours: Int

    static let claudePro = UsagePlan(
        provider: .claude,
        tierName: "Pro",
        tokenLimit: 45_000_000,
        resetIntervalHours: 5
    )
}
