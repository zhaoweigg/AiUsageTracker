import SwiftUI

protocol UsageDataProvider: Sendable {
    func fetchCurrentUsage(plan: UsagePlan) async throws -> UsageSnapshot
}

private struct UsageDataProviderKey: EnvironmentKey {
    static let defaultValue: any UsageDataProvider = ManualUsageProvider()
}

extension EnvironmentValues {
    var usageDataProvider: any UsageDataProvider {
        get { self[UsageDataProviderKey.self] }
        set { self[UsageDataProviderKey.self] = newValue }
    }
}

/// Default provider that creates snapshots from manual user input
struct ManualUsageProvider: UsageDataProvider {
    func fetchCurrentUsage(plan: UsagePlan) async throws -> UsageSnapshot {
        UsageSnapshot(
            provider: plan.provider,
            tokensUsed: 0,
            tokenLimit: plan.tokenLimit,
            resetDate: Date.now.addingTimeInterval(TimeInterval(plan.resetIntervalHours * 3600))
        )
    }
}
