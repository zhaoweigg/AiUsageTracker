import SwiftUI
import Charts

struct UsageHistoryView: View {
    @Environment(UsageStore.self) private var store

    var body: some View {
        List {
            if !store.records.isEmpty {
                Section {
                    Chart(store.records) { record in
                        BarMark(
                            x: .value("Date", record.date, unit: .day),
                            y: .value("Tokens", record.tokensConsumed)
                        )
                        .foregroundStyle(barColor(for: record.peakUsagePercent).gradient)
                    }
                    .frame(height: 200)
                    .chartXAxis {
                        AxisMarks(values: .stride(by: .day)) { _ in
                            AxisValueLabel(format: .dateTime.weekday(.abbreviated))
                        }
                    }
                } header: {
                    Text("Token Usage Over Time")
                }

                Section {
                    ForEach(store.records.sorted(by: { $0.date > $1.date })) { record in
                        UsageRecordRow(record: record)
                    }
                } header: {
                    Text("History")
                }
            } else {
                ContentUnavailableView(
                    "No History",
                    systemImage: "clock",
                    description: Text("Usage records will appear here as you log them.")
                )
            }
        }
        .navigationTitle("History")
    }

    private func barColor(for peakPercent: Double) -> Color {
        switch peakPercent {
        case ..<0.5: .green
        case ..<0.8: .yellow
        default: .red
        }
    }
}

private struct UsageRecordRow: View {
    let record: UsageRecord

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(record.date, style: .date)
                    .font(.headline)
                Text("\(record.tokensConsumed.formatted()) tokens")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            Text("\(Int(record.peakUsagePercent * 100))% peak")
                .font(.caption)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(peakColor.opacity(0.15), in: .capsule)
                .foregroundStyle(peakColor)
        }
    }

    private var peakColor: Color {
        switch record.peakUsagePercent {
        case ..<0.5: .green
        case ..<0.8: .yellow
        default: .red
        }
    }
}
