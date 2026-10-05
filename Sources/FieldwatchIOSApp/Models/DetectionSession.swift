import Foundation

struct DetectionSession: Identifiable, Codable, Equatable {
    let id: UUID
    let startedAt: Date
    let endedAt: Date?
    let observedDeviceCount: Int
    let strongestSignal: Int
    let focus: String
}

final class ObservationStore {
    private let key = "fieldwatch.detection.sessions.v1"

    func load() -> [DetectionSession] {
        guard let data = UserDefaults.standard.data(forKey: key) else { return [] }
        do {
            return try JSONDecoder().decode([DetectionSession].self, from: data)
        } catch {
            return []
        }
    }

    func save(_ sessions: [DetectionSession]) {
        do {
            let data = try JSONEncoder().encode(sessions)
            UserDefaults.standard.set(data, forKey: key)
        } catch {
            assertionFailure("Failed to save sessions: \(error)")
        }
    }
}
