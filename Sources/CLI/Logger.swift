import Foundation
import CLISpinner

public enum Logger {
	private static let pattern = Pattern.dots
	private static let spinner = Spinner(pattern: pattern, color: .lightCyan)

	private static var isStepping = false

	public static func step(_ description: String, succeedPrevious: Bool = true) {
		if isStepping, succeedPrevious {
			spinner.text = description
		} else {
			spinner._text = description
		}
		spinner.pattern = Pattern(from: pattern.symbols.map { $0.applyingColor(.lightCyan) })
		spinner.start()
		isStepping = true
	}

	public static func info(_ description: String, succeedPrevious: Bool = true) {
		if isStepping, succeedPrevious {
			spinner.succeed()
		}
		spinner.info(text: description)
		isStepping = false
	}

	public static func warn(_ description: String, succeedPrevious: Bool = true) {
		if isStepping, succeedPrevious {
			spinner.succeed()
		}
		spinner.warn(text: description)
		isStepping = false
	}

	public static func fail(_ description: String) {
		if isStepping {
			spinner.fail()
			isStepping = false
		} else {
			spinner.fail(text: "An error ocurred")
		}

		let prettifiedErrorDescription = description
			.components(separatedBy: "\n")
			.map { "☛ " + $0 }
			.joined(separator: "\n")

		fputs(prettifiedErrorDescription + "\n", stderr)
	}

	public static func succeed(_ description: String? = nil) {
		if isStepping {
			spinner.succeed(text: description)
			isStepping = false
		}
	}

	public static func finish() {
		spinner.unhideCursor()
	}
}
