import SwiftUI

struct SettingsView: View {
    @ObservedObject var viewModel: FieldwatchViewModel

    var body: some View {
        NavigationStack {
            Form {
                Section("Filter Rules") {
                    Toggle("Show Wi‑Fi", isOn: Binding(
                        get: { viewModel.settings.showWiFi },
                        set: { viewModel.updateSettings { $0.showWiFi = $1 } }
                    ))

                    Toggle("Show Bluetooth", isOn: Binding(
                        get: { viewModel.settings.showBluetooth },
                        set: { viewModel.updateSettings { $0.showBluetooth = $1 } }
                    ))

                    Toggle("Strong signal only", isOn: Binding(
                        get: { viewModel.settings.strongSignalOnly },
                        set: { viewModel.updateSettings { $0.strongSignalOnly = $1 } }
                    ))

                    Toggle("Hide trackers", isOn: Binding(
                        get: { viewModel.settings.hideTrackers },
                        set: { viewModel.updateSettings { $0.hideTrackers = $1 } }
                    ))
                }

                Section("Permissions") {
                    Button("Request Bluetooth + Location Access") {
                        viewModel.requestPermissions()
                    }
                }

                Section("Status") {
                    LabeledContent("Scan", value: viewModel.isScanning ? "Running" : "Idle")
                    LabeledContent("Latitude", value: viewModel.latestLocation?.latitudeString ?? "—")
                    LabeledContent("Longitude", value: viewModel.latestLocation?.longitudeString ?? "—")
                }
            }
            .navigationTitle("Settings")
        }
    }
}

private extension Optional where Wrapped == LocationSample {
    var latitudeString: String {
        guard let self else { return "—" }
        return String(format: "%.5f", self.latitude)
    }

    var longitudeString: String {
        guard let self else { return "—" }
        return String(format: "%.5f", self.longitude)
    }
}
