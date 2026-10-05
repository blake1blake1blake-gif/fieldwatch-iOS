import Foundation

struct RadioDevice: Identifiable, Equatable {
    let id: String
    let name: String
    let identifier: String
    let kind: RadioKind
    let rssi: Int
    let lastSeen: Date
}

enum RadioKind: String, CaseIterable {
    case wifi = "Wi‑Fi"
    case bluetooth = "BLE"
    case unknown = "Unknown"
}
