import SwiftUI

struct ResetCountdownView: View {
    let resetDate: Date

    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: "clock.arrow.circlepath")
                .foregroundStyle(.secondary)
            if resetDate > .now {
                Text("Resets \(resetDate, style: .relative)")
                    .foregroundStyle(.secondary)
            } else {
                Text("Reset available")
                    .foregroundStyle(.green)
            }
        }
        .font(.subheadline)
    }
}
