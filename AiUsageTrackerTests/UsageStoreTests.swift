import Testing
import Foundation
@testable import AiUsageTracker

@MainActor
@Test func storeUpdateSnapshot() {
    let tempURL = FileManager.default.temporaryDirectory.appending(path: "test_usage_\(UUID()).json")
    let store = UsageStore(fileURL: tempURL)

    let snapshot = UsageSnapshot(
        tokensUsed: 5000,
        tokenLimit: 45000,
        resetDate: Date.now.addingTimeInterval(3600)
    )
    store.updateSnapshot(snapshot)

    #expect(store.currentSnapshot?.tokensUsed == 5000)
    #expect(store.currentSnapshot?.tokenLimit == 45000)

    try? FileManager.default.removeItem(at: tempURL)
}

@MainActor
@Test func storeAddRecord() {
    let tempURL = FileManager.default.temporaryDirectory.appending(path: "test_usage_\(UUID()).json")
    let store = UsageStore(fileURL: tempURL)

    let record = UsageRecord(tokensConsumed: 1000, peakUsagePercent: 0.3)
    store.addRecord(record)

    #expect(store.records.count == 1)
    #expect(store.records.first?.tokensConsumed == 1000)

    try? FileManager.default.removeItem(at: tempURL)
}

@MainActor
@Test func storeClearHistory() {
    let tempURL = FileManager.default.temporaryDirectory.appending(path: "test_usage_\(UUID()).json")
    let store = UsageStore(fileURL: tempURL)

    store.addRecord(UsageRecord(tokensConsumed: 100, peakUsagePercent: 0.1))
    store.addRecord(UsageRecord(tokensConsumed: 200, peakUsagePercent: 0.2))
    #expect(store.records.count == 2)

    store.clearHistory()
    #expect(store.records.isEmpty)

    try? FileManager.default.removeItem(at: tempURL)
}

@MainActor
@Test func storePersistsAcrossInstances() {
    let tempURL = FileManager.default.temporaryDirectory.appending(path: "test_usage_\(UUID()).json")

    let store1 = UsageStore(fileURL: tempURL)
    let snapshot = UsageSnapshot(
        tokensUsed: 8000,
        tokenLimit: 45000,
        resetDate: Date.now.addingTimeInterval(3600)
    )
    store1.updateSnapshot(snapshot)

    let store2 = UsageStore(fileURL: tempURL)
    #expect(store2.currentSnapshot?.tokensUsed == 8000)

    try? FileManager.default.removeItem(at: tempURL)
}
