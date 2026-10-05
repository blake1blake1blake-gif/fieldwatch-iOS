// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "FieldwatchIOS",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        .executable(
            name: "FieldwatchIOS",
            targets: ["FieldwatchIOSApp"]
        )
    ],
    targets: [
        .executableTarget(
            name: "FieldwatchIOSApp",
            path: "Sources/FieldwatchIOSApp"
        )
    ]
)
