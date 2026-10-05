import Foundation

struct FieldwatchSettings: Codable, Equatable {
    var showWiFi: Bool = true
    var showBluetooth: Bool = true
    var strongSignalOnly: Bool = false
    var minimumSignalDbm: Int = -80
    var movingWithYou: Bool = false
    var hideTrackers: Bool = false
    var alertOnNewDevice: Bool = false

    static let `default` = FieldwatchSettings()
}
