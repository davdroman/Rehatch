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
		.package(url: "https://github.com/yaslab/CSV.swift", .upToNextMajor(from: "2.4.1")),
		.package(url: "https://github.com/mw99/OhhAuth.git", .upToNextMajor(from: "1.0.0")),
		.package(url: "https://github.com/davdroman/SwiftCLI", .branch("master")),
		.package(url: "https://github.com/httpswift/swifter", .upToNextMajor(from: "1.4.7")),
	],
    targets: [
		.target(
			name: "CLI",
			dependencies: [
				"CSV",
				"CLISpinner",
				"SwiftCLI",
				"Twitter",
			]
		),
		.target(
			name: "Twitter",
			dependencies: [
				"OhhAuth",
				"Sugar",
				"SwiftCLI",
				"Swifter",
			]
		),
		.target(name: "Sugar", dependencies: []),
		.testTarget(
			name: "TwitterTests",
			dependencies: ["Twitter"]
		)
	]
)
