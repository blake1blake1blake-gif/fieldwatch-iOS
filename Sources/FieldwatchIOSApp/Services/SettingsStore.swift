import Foundation

final class SettingsStore {
    private let key = "fieldwatch.settings.v1"

    func load() -> FieldwatchSettings {
        guard let data = UserDefaults.standard.data(forKey: key) else {
            return .default
        }

        do {
            return try JSONDecoder().decode(FieldwatchSettings.self, from: data)
        } catch {
            return .default
        }
    }

    func save(_ settings: FieldwatchSettings) {
        do {
            let data = try JSONEncoder().encode(settings)
            UserDefaults.standard.set(data, forKey: key)
        } catch {
            assertionFailure("Failed to save settings: \(error)")
        }
    }
}
