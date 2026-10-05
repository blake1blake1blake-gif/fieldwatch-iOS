import SwiftUI

struct ReportsView: View {
    @ObservedObject var viewModel: FieldwatchViewModel

    var body: some View {
        NavigationStack {
            List {
                Section("Summary") {
                    LabeledContent("GPS points", value: "\(viewModel.locationSamples.count)")
                    LabeledContent("Detected devices", value: "\(viewModel.filteredDevices.count)")
                    LabeledContent("Sessions", value: "\(viewModel.sessions.count)")
                }

                Section("Sessions") {
                    if viewModel.sessions.isEmpty {
                        Text("No completed sessions yet.")
                            .foregroundStyle(.secondary)
                    } else {
                        ForEach(viewModel.sessions) { session in
                            VStack(alignment: .leading, spacing: 4) {
                                Text(session.focus)
                                    .font(.headline)
                                Text("Started: \(session.startedAt.formatted(date: .abbreviated, time: .shortened))")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                Text("Devices: \(session.observedDeviceCount) • Strongest signal: \(session.strongestSignal)dBm")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                            .padding(.vertical, 4)
                        }
                    }
                }
            }
            .navigationTitle("Reports")
        }
    }
}
