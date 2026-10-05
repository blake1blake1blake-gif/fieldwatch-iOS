import Foundation

struct RadioDevice: Identifiable, Equatable {
    let id: String
    let name: String
    let identifier: String
    let kind: RadioKind
    let rssi: Int
    let lastSeen: Date
    let flags: Set<DeviceFlag>
    let classification: DeviceClassification

    var summary: String {
        "\(classification.displayName) • \(kind.rawValue)"
    }
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

enum DeviceClassification: String, CaseIterable, Codable {
    case unknown = "Unknown"
    case tracker = "Tracker"
    case smartTag = "SmartTag"
    case camera = "Camera"
    case drone = "Drone"
    case accessControl = "Access control"
    case mesh = "Mesh"
    case beacon = "Beacon"
    case wearable = "Wearable"
    case wifiAccessPoint = "Wi‑Fi access point"
    case phone = "Phone"

    var displayName: String {
        rawValue
    }
}
