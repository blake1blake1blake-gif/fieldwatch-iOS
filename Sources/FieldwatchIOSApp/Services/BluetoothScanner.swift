import CoreBluetooth
import Foundation

final class BluetoothScanner: NSObject, CBCentralManagerDelegate {
    typealias DeviceHandler = (RadioDevice) -> Void

    private let manager: CBCentralManager
    private let deviceHandler: DeviceHandler
    private var knownPeripherals: [String: RadioDevice] = [:]

    init(deviceHandler: @escaping DeviceHandler) {
        self.deviceHandler = deviceHandler
        self.manager = CBCentralManager(delegate: nil, queue: nil)
        super.init()
        self.manager.delegate = self
    }

    var isScanning: Bool {
        manager.isScanning
    }

    func startScanning() {
        guard manager.state == .poweredOn else { return }
        manager.scanForPeripherals(withServices: nil, options: [CBCentralManagerScanOptionAllowDuplicatesKey: true])
    }

    func stopScanning() {
        manager.stopScan()
    }

    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn {
            startScanning()
        }
    }

    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String: Any], rssi RSSI: NSNumber) {
        let rawName = peripheral.name ?? (advertisementData[CBAdvertisementDataLocalNameKey] as? String) ?? "Unknown device"
        let identifier = peripheral.identifier.uuidString

        var flags: Set<DeviceFlag> = []
        let lower = rawName.lowercased()
        if lower.contains("tracker") || lower.contains("tile") || lower.contains("tag") {
            flags.insert(.tracker)
        }

        let device = RadioDevice(
            id: identifier,
            name: rawName,
            identifier: identifier,
            kind: .bluetooth,
            rssi: RSSI.intValue,
            lastSeen: Date(),
            flags: flags,
            classification: CatalogMatcher.classify(name: rawName, kind: .bluetooth)
        )

        if knownPeripherals[identifier] != device {
            knownPeripherals[identifier] = device
            deviceHandler(device)
        }
    }
}
