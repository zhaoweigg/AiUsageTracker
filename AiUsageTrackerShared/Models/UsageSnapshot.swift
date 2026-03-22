import Foundation

struct UsageSnapshot: Identifiable, Codable, Sendable {
    let id: UUID
    let provider: AiProvider
    let timestamp: Date
    let tokensUsed: Int
    let tokenLimit: Int
    let resetDate: Date

    var tokensRemaining: Int { tokenLimit - tokensUsed }

    var usagePercentage: Double {
        guard tokenLimit > 0 else { return 0 }
        return Double(tokensUsed) / Double(tokenLimit)
    }

    var timeUntilReset: TimeInterval {
        resetDate.timeIntervalSince(timestamp)
    }

    init(
        id: UUID = UUID(),
        provider: AiProvider = .claude,
        timestamp: Date = .now,
        tokensUsed: Int,
        tokenLimit: Int,
        resetDate: Date
    ) {
        self.id = id
        self.provider = provider
        self.timestamp = timestamp
        self.tokensUsed = tokensUsed
        self.tokenLimit = tokenLimit
        self.resetDate = resetDate
    }
}
