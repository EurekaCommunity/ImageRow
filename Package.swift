// swift-tools-version:5.1
import PackageDescription

let package = Package(
    name: "ImageRow",
    platforms: [.iOS(.v9)],
    products: [
        .library(name: "ImageRow", targets: ["ImageRow"])
    ],
    dependencies: [
        .package(url: "https://github.com/xmartlabs/Eureka.git", from: "5.2.0"),
    ],
    targets: [
        .target(
            name: "ImageRow",
            dependencies: ["Eureka"],
            path: "Sources"
        ),
        .testTarget(
            name: "ImageRowTests",
            dependencies: ["ImageRow"],
            path: "Tests"
        )
    ]
)
