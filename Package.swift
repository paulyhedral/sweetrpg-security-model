// swift-tools-version:4.0
import PackageDescription

let package = Package(
  name: "sweetrpg-security-model",
  products: [
  .library(name: "sweetrpg-security-model", targets: ["Models"])
  ],
      dependencies: [
        // 💧 A server-side Swift web framework.
        .package(url: "https://github.com/vapor/vapor.git", from: "3.0.0"),
        .package(url: "https://github.com/vapor/fluent-provider.git", from: "3.0.0"),
    ],
    targets: [
        .target(
            name: "Models",
            dependencies: ["Vapor", "FluentProvider"]
        ),
        .testTarget(name: "ModelTests", dependencies: ["Models", "Testing"])
    ]
)
