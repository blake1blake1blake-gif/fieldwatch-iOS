import CoreLocation
import Foundation

@MainActor
final class FieldwatchViewModel: ObservableObject {
    @Published var devices: [RadioDevice] = []
    @Published var locationSamples: [LocationSample] = []
    @Published var isScanning = false
    @Published var latestLocation: LocationSample?
    @Published var settings: FieldwatchSettings
    @Published var sessions: [DetectionSession] = []

    private let bluetoothScanner: BluetoothScanner
    private let locationTracker: LocationTracker
    private let settingsStore = SettingsStore()
    private let filterEngine = FilterEngine()
    private let observationStore = ObservationStore()

    var filteredDevices: [RadioDevice] {
        devices.filter { filterEngine.passes($0, rules: settings) }
    }

    init() {
        self.settings = settingsStore.load()
        self.latestLocation = nil
        self.sessions = observationStore.load()

        self.bluetoothScanner = BluetoothScanner { [weak self] device in
            self?.handle(device: device)
        }

        self.locationTracker = LocationTracker { [weak self] sample in
            self?.handle(locationSample: sample)
        }
    }

    func requestPermissions() {
        locationTracker.requestAuthorization()
    }

    func updateSettings(_ mutation: (inout FieldwatchSettings) -> Void) {
        mutation(&settings)
        settingsStore.save(settings)
    }

    func startScanning() {
        bluetoothScanner.startScanning()
        locationTracker.startTracking()
        isScanning = true
        appendSessionIfNeeded()
    }

    func stopScanning() {
        bluetoothScanner.stopScanning()
        locationTracker.stopTracking()
        isScanning = false
        finalizeCurrentSession()
    }

    private func handle(device: RadioDevice) {
        let classified = RadioDevice(
            id: device.id,
            name: device.name,
            identifier: device.identifier,
            kind: device.kind,
            rssi: device.rssi,
            lastSeen: device.lastSeen,
            flags: device.flags,
            classification: CatalogMatcher.classify(name: device.name, kind: device.kind)
        )

        if let index = devices.firstIndex(where: { $0.id == classified.id }) {
            devices[index] = classified
        } else {
            devices.insert(classified, at: 0)
        }

        if isScanning {
            appendSessionIfNeeded()
        }
    }

    private func handle(locationSample: LocationSample) {
        latestLocation = locationSample
        locationSamples.append(locationSample)
        if locationSamples.count > 200 {
            locationSamples.removeFirst(locationSamples.count - 200)
        }
    }

    private func appendSessionIfNeeded() {
        guard isScanning else { return }
        if sessions.last?.endedAt == nil {
            return
        }

        let newSession = DetectionSession(
            id: UUID(),
            startedAt: Date(),
            endedAt: nil,
            observedDeviceCount: max(filteredDevices.count, 0),
            strongestSignal: filteredDevices.map(\.rssi).max() ?? -120,
            focus: "Live radio scan"
        )
        sessions.append(newSession)
        observationStore.save(sessions)
    }

    private func finalizeCurrentSession() {
        guard var current = sessions.last, current.endedAt == nil else { return }
        current = DetectionSession(
            id: current.id,
            startedAt: current.startedAt,
            endedAt: Date(),
            observedDeviceCount: max(filteredDevices.count, 0),
            strongestSignal: filteredDevices.map(\.rssi).max() ?? -120,
            focus: current.focus
        )

        sessions[sessions.count - 1] = current
        observationStore.save(sessions)
    }
}
