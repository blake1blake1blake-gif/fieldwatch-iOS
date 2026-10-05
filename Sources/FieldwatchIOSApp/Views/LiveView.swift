import SwiftUI

struct LiveView: View {
    @ObservedObject var viewModel: FieldwatchViewModel

    var body: some View {
        NavigationStack {
            List(viewModel.filteredDevices) { device in
                NavigationLink(destination: DeviceDetailView(device: device)) {
                    VStack(alignment: .leading, spacing: 6) {
                        HStack {
                            Text(device.name)
                                .font(.headline)
                            Spacer()
                            Text(device.classification.displayName)
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
