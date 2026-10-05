import Foundation

struct RadioDevice: Identifiable, Equatable {
    let id: String
    let name: String
    let identifier: String
    let kind: RadioKind
    let rssi: Int
    let lastSeen: Date
    let flags: Set<DeviceFlag>
}

enum RadioKind: String, CaseIterable {
    case wifi = "Wi‑Fi"
    case bluetooth = "BLE"
    case unknown = "Unknown"
}

enum DeviceFlag: String, CaseIterable {
    case tracker
    case extraAttention
    case named
}

struct LocationSample: Identifiable, Equatable {
    let id: UUID
    let latitude: Double
    let longitude: Double
    let timestamp: Date
}
