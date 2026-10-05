import Foundation

enum CatalogMatcher {
    static let catalog: [CatalogSignature] = [
        CatalogSignature(family: "AirTag", kind: .bluetooth, keywords: ["airtag", "find my"], classification: .tracker, extraAttention: false, tracker: true),
        CatalogSignature(family: "Tile", kind: .bluetooth, keywords: ["tile", "tracker"], classification: .tracker, extraAttention: false, tracker: true),
        CatalogSignature(family: "Samsung SmartTag", kind: .bluetooth, keywords: ["smarttag", "samsung smarttag"], classification: .smartTag, extraAttention: false, tracker: true),
        CatalogSignature(family: "Camera", kind: .bluetooth, keywords: ["camera", "flock", "dashcam", "vivotek", "reolink", "hikvision", "nest cam"], classification: .camera, extraAttention: true, tracker: false),
        CatalogSignature(family: "Drone", kind: .bluetooth, keywords: ["dji", "autel", "skydio", "parrot", "hoverair", "remote id"], classification: .drone, extraAttention: true, tracker: false),
        CatalogSignature(family: "Access control", kind: .bluetooth, keywords: ["assa", "salto", "dormakaba", "paxton", "door lock"], classification: .accessControl, extraAttention: false, tracker: false),
        CatalogSignature(family: "Mesh", kind: .bluetooth, keywords: ["meshtastic", "rak wisgate", "meshcore", "go tenna", "sensecap"], classification: .mesh, extraAttention: false, tracker: false),
        CatalogSignature(family: "Wearable", kind: .bluetooth, keywords: ["apple watch", "fitbit", "garmin", "pixel watch", "smartwatch", "earbuds"], classification: .wearable, extraAttention: false, tracker: false),
        CatalogSignature(family: "Beacon", kind: .bluetooth, keywords: ["ibeacon", "eddystone", "beacon", "find hub", "google find hub"], classification: .beacon, extraAttention: false, tracker: false),
        CatalogSignature(family: "Wi‑Fi AP", kind: .wifi, keywords: ["wifi", "wireless", "ap", "access point"], classification: .wifiAccessPoint, extraAttention: false, tracker: false),
        CatalogSignature(family: "Phone", kind: .wifi, keywords: ["iphone", "android", "pixel", "galaxy", "samsung", "phone"], classification: .phone, extraAttention: false, tracker: false)
    ]

    static func classify(name: String, kind: RadioKind) -> DeviceClassification {
        let normalized = name.lowercased()

        for signature in catalog where signature.kind == kind || signature.kind == .unknown {
            if signature.keywords.contains(where: { normalized.contains($0) }) {
                return signature.classification
            }
        }

        if kind == .bluetooth {
            let lower = normalized
            if lower.contains("tag") || lower.contains("tracker") {
                return .tracker
            }
            if lower.contains("camera") {
                return .camera
            }
        }

        return .unknown
    }
}
