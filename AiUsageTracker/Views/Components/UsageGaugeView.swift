import SwiftUI

struct UsageGaugeView: View {
    let percentage: Double
    let tokensUsed: Int
    let tokenLimit: Int

    private var gaugeColor: Color {
        switch percentage {
        case ..<0.5: .green
        case ..<0.8: .yellow
        default: .red
        }
    }

    var body: some View {
        Gauge(value: percentage) {
            Image(systemName: "brain.head.profile")
        } currentValueLabel: {
            Text("\(Int(percentage * 100))%")
                .font(.system(.title, design: .rounded, weight: .bold))
        } minimumValueLabel: {
            Text("0")
        } maximumValueLabel: {
            Text(tokenLimit.formatted(.number.notation(.compactName)))
        }
        .gaugeStyle(.accessoryCircularCapacity)
        .tint(gaugeColor)
        .scaleEffect(2.5)
    }
}
