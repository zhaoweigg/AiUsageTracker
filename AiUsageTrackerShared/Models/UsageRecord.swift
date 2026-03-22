import Foundation

struct UsageRecord: Identifiable, Codable, Sendable {
    let id: UUID
    let provider: AiProvider
    let date: Date
    let tokensConsumed: Int
    let peakUsagePercent: Double

    init(
        id: UUID = UUID(),
        provider: AiProvider = .claude,
        date: Date = .now,
        tokensConsumed: Int,
        peakUsagePercent: Double
    ) {
        self.id = id
        self.provider = provider
        self.date = date
        self.tokensConsumed = tokensConsumed
        self.peakUsagePercent = peakUsagePercent
    }
}
