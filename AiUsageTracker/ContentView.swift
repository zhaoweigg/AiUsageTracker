import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            Tab("Dashboard", systemImage: "gauge.with.dots.needle.33percent") {
                NavigationStack {
                    DashboardView()
                }
            }
            Tab("History", systemImage: "chart.xyaxis.line") {
                NavigationStack {
                    UsageHistoryView()
                }
            }
            Tab("Settings", systemImage: "gear") {
                NavigationStack {
                    SettingsView()
                }
            }
        }
    }
}
