import SwiftUI

struct DeviceDetailView: View {
    let device: RadioDevice

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                header
                detailsSection
                metadataSection
            }
            .padding()
        }
        .navigationTitle(device.name)
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(device.name)
                .font(.largeTitle.bold())

            HStack {
                Text(device.classification.displayName)
                    .font(.headline)
                Spacer()
                Text(device.kind.rawValue)
                    .font(.caption)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.cyan.opacity(0.2))
                    .clipShape(Capsule())
            }
        }
    }

    private var detailsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Device details")
                .font(.title3.bold())

            DetailRow(label: "Identifier", value: device.identifier)
            DetailRow(label: "RSSI", value: "\(device.rssi) dBm")
            DetailRow(label: "Last seen", value: device.lastSeen.formatted(date: .abbreviated, time: .shortened))
            DetailRow(label: "Flags", value: device.flags.isEmpty ? "None" : device.flags.map(\.rawValue).joined(separator: ", "))
        }
    }

    private var metadataSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Metadata")
                .font(.title3.bold())

            DetailRow(label: "Classification", value: device.classification.displayName)
            DetailRow(label: "Tracking", value: device.flags.contains(.tracker) ? "Tracker-like" : "Normal")
            DetailRow(label: "Extra attention", value: device.flags.contains(.extraAttention) ? "Yes" : "No")
        }
    }
}

private struct DetailRow: View {
    let label: String
    let value: String

    var body: some View {
        HStack(alignment: .top) {
            Text(label)
                .frame(width: 120, alignment: .leading)
                .foregroundStyle(.secondary)
            Text(value)
                .multilineTextAlignment(.leading)
            Spacer()
        }
    }
}
