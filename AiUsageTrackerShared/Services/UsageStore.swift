import Foundation
import WidgetKit

struct UsageData: Codable, Sendable {
    var currentSnapshot: UsageSnapshot?
    var plan: UsagePlan
    var records: [UsageRecord]
}

@MainActor
@Observable
final class UsageStore {
    private(set) var currentSnapshot: UsageSnapshot?
    var plan: UsagePlan
    private(set) var records: [UsageRecord] = []

    private let fileURL: URL

    init(fileURL: URL? = nil) {
        let defaultURL = AppGroupConstants.containerURL.appending(path: "usage_data.json")
        self.fileURL = fileURL ?? defaultURL
        self.plan = .claudePro
        load()
    }

    func updateSnapshot(_ snapshot: UsageSnapshot) {
        currentSnapshot = snapshot
        save()
    }

    func addRecord(_ record: UsageRecord) {
        records.append(record)
        save()
    }

    func updatePlan(_ plan: UsagePlan) {
        self.plan = plan
        save()
    }

    func clearHistory() {
        records.removeAll()
        save()
    }

    // MARK: - Persistence

    private func load() {
        do {
            let data = try Data(contentsOf: fileURL)
            let decoded = try JSONDecoder().decode(UsageData.self, from: data)
            currentSnapshot = decoded.currentSnapshot
            plan = decoded.plan
            records = decoded.records
        } catch {
            plan = .claudePro
        }
    }

    private func save() {
        do {
            let dir = fileURL.deletingLastPathComponent()
            try FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
            let usageData = UsageData(currentSnapshot: currentSnapshot, plan: plan, records: records)
            let data = try JSONEncoder().encode(usageData)
            try data.write(to: fileURL, options: .atomic)
            WidgetCenter.shared.reloadAllTimelines()
        } catch {
            print("Failed to save usage data: \(error)")
        }
    }

    /// Read-only access for the widget (no @Observable needed)
    static func loadData(from fileURL: URL? = nil) -> UsageData {
        let url = fileURL ?? AppGroupConstants.containerURL.appending(path: "usage_data.json")
        do {
            let data = try Data(contentsOf: url)
            return try JSONDecoder().decode(UsageData.self, from: data)
        } catch {
            return UsageData(currentSnapshot: nil, plan: .claudePro, records: [])
        }
    }
}
