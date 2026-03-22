import SwiftUI

struct UsageTrendBadge: View {
    let records: [UsageRecord]

    private var trend: (symbol: String, color: Color, text: String) {
        guard records.count >= 2 else {
            return ("minus", .secondary, "No trend data")
        }

        let recent = records.suffix(3).map(\.peakUsagePercent)
        let older = records.dropLast(min(3, records.count)).suffix(3).map(\.peakUsagePercent)

        guard !older.isEmpty else {
            return ("minus", .secondary, "Building trend")
        }

        let recentAvg = recent.reduce(0, +) / Double(recent.count)
        let olderAvg = older.reduce(0, +) / Double(older.count)
        let delta = recentAvg - olderAvg

        if abs(delta) < 0.05 {
            return ("equal", .secondary, "Stable usage")
        } else if delta > 0 {
            return ("arrow.up.right", .red, "Usage trending up")
        } else {
            return ("arrow.down.right", .green, "Usage trending down")
        }
    }

    var body: some View {
        let t = trend
        Label(t.text, systemImage: t.symbol)
            .font(.subheadline)
            .foregroundStyle(t.color)
    }
}
