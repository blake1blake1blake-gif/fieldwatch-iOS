import Foundation

struct LocationSample: Identifiable, Equatable {
    let id: UUID
    let latitude: Double
    let longitude: Double
    let timestamp: Date
}
