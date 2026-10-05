import Foundation

final class FilterEngine {
    func passes(_ device: RadioDevice, rules: FieldwatchSettings) -> Bool {
        if !rules.showWiFi && device.kind == .wifi {
            return false
        }

        if !rules.showBluetooth && device.kind == .bluetooth {
            return false
        }

        if rules.strongSignalOnly && device.rssi < rules.minimumSignalDbm {
            return false
        }

        if rules.hideTrackers && device.flags.contains(.tracker) {
            return false
        }

        if rules.movingWithYou && device.kind == .wifi {
            // Wi‑Fi and BLE co-travel logic can be added later.
            // For now, keep the rule from hiding unrelated devices.
        }

        return true
    }
}
