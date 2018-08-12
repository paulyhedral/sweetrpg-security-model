// swift-tools-version:4.0
import PackageDescription

let package = Package(
    name: "SweetRPGSecurityModel",
    products: [
        .library(name: "SweetRPGSecurityModel", targets: ["Library"]),
    ],
    dependencies: [
        // 💧 A server-side Swift web framework.
        // .package(url: "https://github.com/vapor/vapor.git", from: "3.0.0"),

        // 🔵 Swift ORM (queries, models, relations, etc) built on SQLite 3.
        .package(url: "https://github.com/vapor/fluent-mysql.git", from: "3.0.0"),
    ],
    targets: [
        .target(name: "Library", dependencies: ["FluentMySQL", "Vapor"]),
        .testTarget(name: "LibraryTests", dependencies: ["Library"]),
    ]
)
