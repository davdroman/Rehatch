import PackageDescription

let package = Package(
    name: "Rehatch",
    targets: [
		Target(
			name: "Rehatch",
			dependencies: ["RehatchCore"]
		),
		Target(name: "RehatchCore")
	],
	dependencies: [
		.Package(url: "https://github.com/jatoben/CommandLine", "3.0.0-pre1"),
		.Package(url: "https://github.com/devxoul/Then", "2.1.0"),
		.Package(url: "https://github.com/yaslab/CSV.swift.git", majorVersion: 1, minor: 1),
		.Package(url: "https://github.com/antitypical/Result.git", majorVersion: 3),
		.Package(url: "https://github.com/mw99/OhhAuth.git", majorVersion: 1)
	]
)
