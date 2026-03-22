import Foundation

enum AppGroupConstants {
    static let suiteName = "group.com.personal.aiusagetracker"

    static var containerURL: URL {
        FileManager.default.containerURL(
            forSecurityApplicationGroupIdentifier: suiteName
        ) ?? URL.applicationSupportDirectory
    }
}
