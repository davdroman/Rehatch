import PackageDescription

let package = Package(
    name: "Rehatch",
    dependencies: [
        .Package(url: "https://github.com/jatoben/CommandLine", "3.0.0-pre1"),
		.Package(url: "https://github.com/mattdonnelly/Swifter", "2.0.1"),
		.Package(url: "https://github.com/devxoul/Then", "2.1.0"),
		.Package(url: "https://github.com/yaslab/CSV.swift.git", majorVersion: 1, minor: 1),
		.Package(url: "https://github.com/antitypical/Result.git", majorVersion: 3)
    ]
)
