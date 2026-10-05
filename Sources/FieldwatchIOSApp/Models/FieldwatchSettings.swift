import Foundation

struct FieldwatchSettings: Codable, Equatable {
    var showWiFi: Bool = true
    var showBluetooth: Bool = true
    var showBLE: Bool = true
    var strongSignalOnly: Bool = false
    var minimumSignalDbm: Int = -80
    var rssiMin: Int = -80
    var movingWithYou: Bool = false
    var hideTrackers: Bool = false
    var alertOnNewDevice: Bool = false
    var namedOnly: Bool = false
    var customNamesOnly: Bool = false
    var watchedOnly: Bool = false
    var hideMine: Bool = false
    var nameQuery: String = ""
    var ouiQuery: String = ""
    var hideFastPairAccountKey: Bool = false

    var effectiveSignalFloor: Int {
        max(minimumSignalDbm, rssiMin)
    }

    static let `default` = FieldwatchSettings()
}
