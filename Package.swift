// swift-tools-version:5.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Rehatch",
	platforms: [
		.macOS(.v10_13)
	],
	products: [
		.executable(name: "rehatch", targets: ["RehatchCLI"]),
	],
	dependencies: [
		.package(url: "https://github.com/davdroman/CLISpinner", .branch("master")),
		.package(url: "https://github.com/yaslab/CSV.swift", .upToNextMajor(from: "2.4.3")),
		.package(url: "https://github.com/mw99/OhhAuth.git", .upToNextMajor(from: "1.0.0")),
		.package(url: "https://github.com/apple/swift-argument-parser", .upToNextMajor(from: "0.3.0")),
        .package(url: "https://github.com/JohnSundell/ShellOut", .upToNextMajor(from: "2.3.0")),
		.package(url: "https://github.com/httpswift/swifter", .upToNextMajor(from: "1.4.7")),
	],
    targets: [
		.target(
			name: "RehatchCLI",
			dependencies: [
                "ArgumentParser",
				"CLISpinner",
                "ShellOut",
				"Twitter",
			]
		),
		.target(
			name: "Twitter",
			dependencies: [
                "Swifter",
                "OhhAuth",
                "ShellOut",
                "CSV",
                "Sugar",
			]
		),
		.target(name: "Sugar", dependencies: []),
		.testTarget(
			name: "TwitterTests",
			dependencies: ["Twitter"]
		)
	]
)
