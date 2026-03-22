import SwiftUI

@main
struct AiUsageTrackerApp: App {
    @State private var usageStore = UsageStore()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(usageStore)
        }
    }
}
