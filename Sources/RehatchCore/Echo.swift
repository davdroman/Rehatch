//
//  Echo.swift
//  Rehatch
//
//  Created by David Roman on 06/07/2017.
//
//

import Foundation

func run(_ arguments: [String]) {
	let echo = Process()
	echo.launchPath = "/usr/bin/env"
	echo.arguments = arguments
	echo.launch()
	echo.waitUntilExit()
}

public func echo(_ output: String) {
	run(["echo", output])
}

func echoPermanent(_ output: String) {
	run(["echo", "-n", "\(output)\r"])
}

public func echoProgress(current: Int, total: Int, maximum: Int = 50) {
	let progress = Double(current) / Double(total)

	let maximumFillerCount = maximum
	let fillerCount = Int(Double(maximumFillerCount) * progress)
	let blankCount = maximumFillerCount - fillerCount

	let filler = Array(repeating: "#", count: fillerCount).joined()
	let blank = Array(repeating: " ", count: blankCount).joined()

	echoPermanent("|\(filler)\(blank)| (\(current)/\(total))")
}

public func echo() {
	echo("")
}

public func echoNewLine() {
	echo("\n")
}
