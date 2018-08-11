// swift-tools-version:4.0
import PackageDescription

let package = Package(
  name: "sweetrpg-security-model",
  products: [
  .library(name: "SecurityModel", targets: ["Model"])
  ],
      dependencies: [
        // 💧 A server-side Swift web framework.
        .package(url: "https://github.com/vapor/vapor.git", from: "3.0.0"),
        .package(url: "https://github.com/vapor/fluent-provider.git", from: "3.0.0"),
    ],
    targets: [
        .target(
            name: "Model",
            dependencies: ["Vapor", "FluentProvider"]
        ),
        .testTarget(name: "ModelTests", dependencies: ["Model", "Testing"])
    ]
)
