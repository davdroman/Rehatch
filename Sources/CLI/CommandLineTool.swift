import Foundation
import SwiftCLI

public final class CommandLineTool {
	enum Constant {
		static let version = "2.0.0"
	}

	public init() {}

	public func run() {
		let cli = CLI(singleCommand: RehatchCommand())

		// Intercept CTRL+C exit sequence
		signal(SIGINT) { _ in
			Logger.finish()
			exit(EXIT_SUCCESS)
		}

		cli.handleErrorClosure = { error in
			Logger.fail(error.localizedDescription)
		}

		let exitStatus = cli.go()

		Logger.finish()
		exit(exitStatus)
	}
}
