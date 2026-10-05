import CoreLocation
import Foundation

final class LocationTracker: NSObject, CLLocationManagerDelegate {
    typealias LocationHandler = (LocationSample) -> Void

    private let manager: CLLocationManager
    private let locationHandler: LocationHandler

    init(locationHandler: @escaping LocationHandler) {
        self.manager = CLLocationManager()
        self.locationHandler = locationHandler
        super.init()
        self.manager.delegate = self
        self.manager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
    }

    func requestAuthorization() {
        manager.requestWhenInUseAuthorization()
    }

    func startTracking() {
        manager.startUpdatingLocation()
    }

    func stopTracking() {
        manager.stopUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        let sample = LocationSample(
            id: UUID(),
            latitude: location.coordinate.latitude,
            longitude: location.coordinate.longitude,
            timestamp: Date()
        )
        locationHandler(sample)
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location error: \(error.localizedDescription)")
    }
}
