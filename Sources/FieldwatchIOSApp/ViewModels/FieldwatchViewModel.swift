import Foundation

@MainActor
final class FieldwatchViewModel: ObservableObject {
    @Published var devices: [RadioDevice] = []
    @Published var locationSamples: [LocationSample] = []
    @Published var isScanning = false
    @Published var latestLocation: LocationSample?
    @Published var settings: FieldwatchSettings

    private let bluetoothScanner: BluetoothScanner
    private let locationTracker: LocationTracker
    private let settingsStore = SettingsStore()
    private let filterEngine = FilterEngine()

    var filteredDevices: [RadioDevice] {
        devices.filter { filterEngine.passes($0, rules: settings) }
    }

    init() {
        self.settings = settingsStore.load()
        self.latestLocation = nil

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
    }

    func stopScanning() {
        bluetoothScanner.stopScanning()
        locationTracker.stopTracking()
        isScanning = false
    }

    private func handle(device: RadioDevice) {
        if let index = devices.firstIndex(where: { $0.id == device.id }) {
            devices[index] = device
        } else {
            devices.insert(device, at: 0)
        }
    }

    private func handle(locationSample: LocationSample) {
        latestLocation = locationSample
        locationSamples.append(locationSample)
        if locationSamples.count > 200 {
            locationSamples.removeFirst(locationSamples.count - 200)
        }
    }
}
