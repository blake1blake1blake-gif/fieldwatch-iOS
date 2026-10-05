# Fieldwatch iOS conversion starter

This repository now includes an initial SwiftUI starter for a Fieldwatch iOS app aimed at iOS 16. The goal is to preserve the current Android application’s radio-monitoring concept while translating the behavior into iOS-native SwiftUI, CoreBluetooth, and CoreLocation.

## Included in this starter

- SwiftUI app shell with a `Live`, `Reports`, and `Settings` layout
- `FieldwatchViewModel` that manages state for live radio observations
- `BluetoothScanner` service using `CoreBluetooth`
- `LocationTracker` service using `CoreLocation`
- Data models for observed Bluetooth/Wi‑Fi-like radios and GPS samples

## App architecture direction

The current Android codebase is organized around several concepts that map well to iOS:

- `ScanService` / radio scanning → `BluetoothScanner` and future Wi‑Fi/NEHotspot integration
- `FieldwatchViewModel` → SwiftUI view model/state controller
- `DeviceStore` / `ConfigStore` → `UserDefaults` + app state store
- `RadioDb` catalog matching → catalog service layer
- `TakPublisher` → future CoT / network export service

## Notes

This is intentionally a conversion scaffold, not a full port of the Android app’s entire logic. The most important next step is to port the Android device/radio classification and filtering logic into Swift models and view-model rules before building the richer report and sit-export screens.

## Open next tasks

1. Port the Android radio catalog and classification rules into Swift models.
2. Map Android `FilterEngine` logic to Swift `FilterRules`.
3. Design the iOS equivalent of `Sits`, `Debrief`, and live activity behavior.
4. Add a persistence layer for named radios, saved filters, and session data.
5. Add network export support for ATAK / CoT-style feeds when required.

## Running the starter

From the repository root:

```bash
swift build
```

Open the package in Xcode to run it on an iOS 16+ simulator or device.
