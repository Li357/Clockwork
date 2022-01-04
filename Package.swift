// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Clockwork",
    products: [
        .library(
            name: "Clockwork",
            targets: ["Clockwork"]),
    ],
    dependencies: [
	.package(url: "https://github.com/stephencelis/SQLite.swift.git", from: "0.13.1")
    ],
    targets: [
        .target(
            name: "Clockwork",
            dependencies: []),
    ]
)
