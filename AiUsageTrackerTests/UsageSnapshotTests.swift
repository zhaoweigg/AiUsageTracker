import Foundation
import Testing
@testable import AiUsageTracker

@Test func tokensRemaining() {
    let snapshot = UsageSnapshot(
        tokensUsed: 10_000,
        tokenLimit: 45_000,
        resetDate: Date.now.addingTimeInterval(3600)
    )
    #expect(snapshot.tokensRemaining == 35_000)
}

@Test func usagePercentage() {
    let snapshot = UsageSnapshot(
        tokensUsed: 22_500,
        tokenLimit: 45_000,
        resetDate: Date.now.addingTimeInterval(3600)
    )
    #expect(snapshot.usagePercentage == 0.5)
}

@Test func usagePercentageZeroLimit() {
    let snapshot = UsageSnapshot(
        tokensUsed: 0,
        tokenLimit: 0,
        resetDate: Date.now
    )
    #expect(snapshot.usagePercentage == 0)
}

@Test func timeUntilReset() {
    let now = Date.now
    let resetDate = now.addingTimeInterval(7200)
    let snapshot = UsageSnapshot(
        timestamp: now,
        tokensUsed: 1000,
        tokenLimit: 10000,
        resetDate: resetDate
    )
    #expect(abs(snapshot.timeUntilReset - 7200) < 1)
}
