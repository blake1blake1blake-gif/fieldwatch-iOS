import SwiftUI

@main
struct FieldwatchIOSApp: App {
    @StateObject private var viewModel = FieldwatchViewModel()

    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: viewModel)
                .preferredColorScheme(.dark)
        }
    }
}

struct ContentView: View {
    @ObservedObject var viewModel: FieldwatchViewModel

    var body: some View {
        TabView {
            LiveView(viewModel: viewModel)
                .tabItem {
                    Label("Live", systemImage: "dot.radiowaves.left.and.right")
                }

            ReportsView(viewModel: viewModel)
                .tabItem {
                    Label("Reports", systemImage: "chart.line.uptrend.xyaxis")
                }

            SettingsView(viewModel: viewModel)
                .tabItem {
                    Label("Settings", systemImage: "gearshape")
                }
        }
        .tint(.cyan)
    }
}

struct LiveView: View {
    @ObservedObject var viewModel: FieldwatchViewModel

    var body: some View {
        NavigationStack {
            List(viewModel.filteredDevices) { device in
                VStack(alignment: .leading, spacing: 6) {
                    HStack {
                        Text(device.name)
                            .font(.headline)
                        Spacer()
                        Text(device.kind.rawValue)
                            .font(.caption)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.cyan.opacity(0.2))
                            .clipShape(Capsule())
                    }

                    Text(device.identifier)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)

                    HStack {
                        Label("RSSI \(device.rssi)", systemImage: "wifi")
                        Spacer()
                        Label(device.lastSeen.formatted(date: .omitted, time: .shortened), systemImage: "clock")
                    }
                    .font(.caption)
                    .foregroundStyle(.secondary)
                }
                .padding(.vertical, 4)
            }
            .navigationTitle("Fieldwatch")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(viewModel.isScanning ? "Stop" : "Scan") {
                        if viewModel.isScanning {
                            viewModel.stopScanning()
                        } else {
                            viewModel.startScanning()
                        }
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
        }
    }
}

struct ReportsView: View {
    @ObservedObject var viewModel: FieldwatchViewModel

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 16) {
                Text("Path")
                    .font(.title2)
                    .bold()

                Text("Observed GPS points: \(viewModel.locationSamples.count)")
                    .foregroundStyle(.secondary)

                Text("Detected devices: \(viewModel.filteredDevices.count)")
                    .foregroundStyle(.secondary)

                Spacer()
            }
            .padding()
            .navigationTitle("Reports")
        }
    }
}

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
