// swift-tools-version:5.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Rehatch",
	platforms: [
		.macOS(.v10_13)
	],
	products: [
		.executable(name: "rehatch", targets: ["CLI"]),
	],
	dependencies: [
		.package(url: "https://github.com/davdroman/CLISpinner", .branch("master")),
		.package(url: "https://github.com/davdroman/SwiftCLI", .branch("master")),
		.package(url: "https://github.com/davdroman/CodableCSV", .branch("swift-pm")),
		.package(url: "https://github.com/mw99/OhhAuth.git", .upToNextMajor(from: "1.0.0"))
	],
    targets: [
		.target(
			name: "CLI",
			dependencies: [
				"Core",
				"CLISpinner",
				"SwiftCLI"
			]
		),
		.target(
			name: "Core",
			dependencies: ["CodableCSV"]
		),
		.target(
			name: "Twitter",
			dependencies: ["OhhAuth"]
		),
		.testTarget(
			name: "CoreTests",
			dependencies: []
		)
	]
)
