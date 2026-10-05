import Foundation

struct CatalogSignature {
    let family: String
    let kind: RadioKind
    let keywords: [String]
    let classification: DeviceClassification
    let extraAttention: Bool
    let tracker: Bool
}
