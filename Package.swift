import PackageDescription

let package = Package(
  name: "Models",
  products: [
  .library(name: "Models"
  ],
      dependencies: [
        .package(url: "https://github.com/vapor/vapor.git", .upToNextMajor(from: "2.1.0")),
        .package(url: "https://github.com/vapor/fluent-provider.git", .upToNextMajor(from: "1.2.0")),
    ],
    targets: [
        .target(
            name: "Models",
            dependencies: ["Vapor", "FluentProvider"],
        ),
        .testTarget(name: "ModelTests", dependencies: ["Models", "Testing"])
    ]
)
