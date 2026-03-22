import SwiftUI

struct DashboardView: View {
    @Environment(UsageStore.self) private var store

    var body: some View {
        ScrollView {
            VStack(spacing: 32) {
                if let snapshot = store.currentSnapshot {
                    usageContent(snapshot)
                } else {
                    emptyState
                }
            }
            .padding()
        }
        .navigationTitle("Dashboard")
    }

    private func usageContent(_ snapshot: UsageSnapshot) -> some View {
        VStack(spacing: 32) {
            // Gauge
            UsageGaugeView(
                percentage: snapshot.usagePercentage,
                tokensUsed: snapshot.tokensUsed,
                tokenLimit: snapshot.tokenLimit
            )
            .frame(height: 160)
            .padding(.top, 24)

            // Token counts
            VStack(spacing: 8) {
                Text(snapshot.tokensRemaining.formatted())
                    .font(.system(.largeTitle, design: .rounded, weight: .bold))
                Text("tokens remaining")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            // Provider & reset
            VStack(spacing: 12) {
                Label(snapshot.provider.displayName, systemImage: snapshot.provider.systemImage)
                    .font(.headline)
                ResetCountdownView(resetDate: snapshot.resetDate)
                UsageTrendBadge(records: store.records)
            }

            // Stats grid
            statsGrid(snapshot)
        }
    }

    private func statsGrid(_ snapshot: UsageSnapshot) -> some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
            StatCard(title: "Used", value: snapshot.tokensUsed.formatted(.number.notation(.compactName)), icon: "flame.fill", color: .orange)
            StatCard(title: "Limit", value: snapshot.tokenLimit.formatted(.number.notation(.compactName)), icon: "target", color: .blue)
            StatCard(title: "Sessions", value: "\(store.records.count)", icon: "list.bullet", color: .purple)
            StatCard(
                title: "Plan",
                value: store.plan.tierName,
                icon: "creditcard.fill",
                color: .green
            )
        }
    }

    private var emptyState: some View {
        ContentUnavailableView {
            Label("No Usage Data", systemImage: "chart.bar.doc.horizontal")
        } description: {
            Text("Log your first token usage in Settings to start tracking.")
        } actions: {
            NavigationLink("Go to Settings") {
                SettingsView()
            }
            .buttonStyle(.borderedProminent)
        }
    }
}

private struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color

    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(color)
            Text(value)
                .font(.system(.title3, design: .rounded, weight: .semibold))
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(.fill.quaternary, in: .rect(cornerRadius: 12))
    }
}
