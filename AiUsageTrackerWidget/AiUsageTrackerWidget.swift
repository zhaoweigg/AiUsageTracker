import WidgetKit
import SwiftUI

struct UsageEntry: TimelineEntry {
    let date: Date
    let snapshot: UsageSnapshot?
    let plan: UsagePlan

    static let placeholder = UsageEntry(
        date: .now,
        snapshot: UsageSnapshot(
            tokensUsed: 15_000_000,
            tokenLimit: 45_000_000,
            resetDate: Date.now.addingTimeInterval(3 * 3600)
        ),
        plan: .claudePro
    )
}

struct UsageTimelineProvider: TimelineProvider {
    func placeholder(in context: Context) -> UsageEntry {
        .placeholder
    }

    func getSnapshot(in context: Context, completion: @escaping (UsageEntry) -> Void) {
        let data = UsageStore.loadData()
        let entry = UsageEntry(date: .now, snapshot: data.currentSnapshot, plan: data.plan)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<UsageEntry>) -> Void) {
        let data = UsageStore.loadData()
        let entry = UsageEntry(date: .now, snapshot: data.currentSnapshot, plan: data.plan)

        let nextUpdate: Date
        if let resetDate = data.currentSnapshot?.resetDate, resetDate > .now {
            nextUpdate = min(resetDate, Date.now.addingTimeInterval(15 * 60))
        } else {
            nextUpdate = Date.now.addingTimeInterval(15 * 60)
        }

        let timeline = Timeline(entries: [entry], policy: .after(nextUpdate))
        completion(timeline)
    }
}

struct UsageWidgetEntryView: View {
    var entry: UsageEntry
    @Environment(\.widgetFamily) var family

    var body: some View {
        switch family {
        case .systemSmall:
            smallWidget
        case .systemMedium:
            mediumWidget
        case .accessoryCircular:
            circularWidget
        default:
            smallWidget
        }
    }

    private var smallWidget: some View {
        VStack(spacing: 8) {
            if let snapshot = entry.snapshot {
                Gauge(value: snapshot.usagePercentage) {
                    Image(systemName: "brain.head.profile")
                } currentValueLabel: {
                    Text("\(Int(snapshot.usagePercentage * 100))%")
                        .font(.system(.title3, design: .rounded, weight: .bold))
                }
                .gaugeStyle(.accessoryCircularCapacity)
                .tint(gaugeColor(snapshot.usagePercentage))
                .scaleEffect(1.5)

                Text("\(snapshot.tokensRemaining.formatted(.number.notation(.compactName))) left")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            } else {
                Image(systemName: "chart.bar.doc.horizontal")
                    .font(.title)
                    .foregroundStyle(.secondary)
                Text("No data")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
    }

    private var mediumWidget: some View {
        HStack(spacing: 16) {
            if let snapshot = entry.snapshot {
                Gauge(value: snapshot.usagePercentage) {
                    Image(systemName: "brain.head.profile")
                } currentValueLabel: {
                    Text("\(Int(snapshot.usagePercentage * 100))%")
                        .font(.system(.title3, design: .rounded, weight: .bold))
                }
                .gaugeStyle(.accessoryCircularCapacity)
                .tint(gaugeColor(snapshot.usagePercentage))
                .scaleEffect(1.8)
                .frame(width: 80)

                VStack(alignment: .leading, spacing: 6) {
                    Text(snapshot.provider.displayName)
                        .font(.headline)
                    Text("\(snapshot.tokensRemaining.formatted(.number.notation(.compactName))) tokens left")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    if snapshot.resetDate > .now {
                        HStack(spacing: 4) {
                            Image(systemName: "clock.arrow.circlepath")
                            Text(snapshot.resetDate, style: .relative)
                        }
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    }
                }
            } else {
                ContentUnavailableView("No data", systemImage: "chart.bar.doc.horizontal")
            }
        }
    }

    private var circularWidget: some View {
        Group {
            if let snapshot = entry.snapshot {
                Gauge(value: snapshot.usagePercentage) {
                    Image(systemName: "brain.head.profile")
                } currentValueLabel: {
                    Text("\(Int(snapshot.usagePercentage * 100))%")
                }
                .gaugeStyle(.accessoryCircularCapacity)
                .tint(gaugeColor(snapshot.usagePercentage))
            } else {
                Image(systemName: "brain.head.profile")
                    .foregroundStyle(.secondary)
            }
        }
    }

    private func gaugeColor(_ percentage: Double) -> Color {
        switch percentage {
        case ..<0.5: .green
        case ..<0.8: .yellow
        default: .red
        }
    }
}

@main
struct AiUsageTrackerWidget: Widget {
    let kind = "AiUsageTrackerWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: UsageTimelineProvider()) { entry in
            UsageWidgetEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .configurationDisplayName("AI Usage")
        .description("Track your AI token usage at a glance.")
        .supportedFamilies([.systemSmall, .systemMedium, .accessoryCircular])
    }
}
