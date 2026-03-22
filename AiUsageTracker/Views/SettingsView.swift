import SwiftUI

struct SettingsView: View {
    @Environment(UsageStore.self) private var store

    @State private var tokensUsed: String = ""
    @State private var tokenLimit: String = ""
    @State private var hoursUntilReset: String = ""
    @State private var selectedTier: String = "Pro"

    private let tiers = [
        ("Free", 1_000_000),
        ("Pro", 45_000_000),
        ("Team", 90_000_000),
    ]

    var body: some View {
        Form {
            planSection
            logUsageSection
            historySection
        }
        .navigationTitle("Settings")
        .onAppear {
            tokenLimit = "\(store.plan.tokenLimit)"
            selectedTier = store.plan.tierName
        }
    }

    private var planSection: some View {
        Section("Plan") {
            Picker("Provider", selection: .constant(AiProvider.claude)) {
                ForEach(AiProvider.allCases) { provider in
                    Label(provider.displayName, systemImage: provider.systemImage)
                        .tag(provider)
                }
            }

            Picker("Tier", selection: $selectedTier) {
                ForEach(tiers, id: \.0) { tier in
                    Text(tier.0).tag(tier.0)
                }
            }
            .onChange(of: selectedTier) { _, newTier in
                if let match = tiers.first(where: { $0.0 == newTier }) {
                    let newPlan = UsagePlan(
                        provider: .claude,
                        tierName: match.0,
                        tokenLimit: match.1,
                        resetIntervalHours: 5
                    )
                    store.updatePlan(newPlan)
                    tokenLimit = "\(match.1)"
                }
            }

            LabeledContent("Token Limit") {
                Text(store.plan.tokenLimit.formatted())
            }

            LabeledContent("Reset Interval") {
                Text("\(store.plan.resetIntervalHours) hours")
            }
        }
    }

    private var logUsageSection: some View {
        Section("Log Usage") {
            TextField("Tokens used", text: $tokensUsed)
                .keyboardType(.numberPad)

            TextField("Hours until reset", text: $hoursUntilReset)
                .keyboardType(.decimalPad)

            Button("Log Current Usage") {
                logUsage()
            }
            .disabled(tokensUsed.isEmpty)
        }
    }

    private var historySection: some View {
        Section {
            Button("Clear History", role: .destructive) {
                store.clearHistory()
            }
            .disabled(store.records.isEmpty)
        }
    }

    private func logUsage() {
        guard let used = Int(tokensUsed) else { return }
        let limit = store.plan.tokenLimit
        let hours = Double(hoursUntilReset) ?? Double(store.plan.resetIntervalHours)
        let resetDate = Date.now.addingTimeInterval(hours * 3600)

        let snapshot = UsageSnapshot(
            tokensUsed: used,
            tokenLimit: limit,
            resetDate: resetDate
        )
        store.updateSnapshot(snapshot)

        let record = UsageRecord(
            tokensConsumed: used,
            peakUsagePercent: snapshot.usagePercentage
        )
        store.addRecord(record)

        tokensUsed = ""
        hoursUntilReset = ""
    }
}
