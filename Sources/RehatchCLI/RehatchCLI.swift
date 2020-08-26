import Foundation

struct RehatchCLI {
    static func main() {
        let cli = RehatchCommand.parseOrExit()

        // Intercept CTRL+C exit sequence
        signal(SIGINT) { _ in
            Logger.finish()
            exit(EXIT_SUCCESS)
        }

        switch Result(catching: cli.run) {
        case .success:
            Logger.finish()
            exit(EXIT_SUCCESS)
        case .failure(let error):
            Logger.fail(error.localizedDescription)
            exit(EXIT_FAILURE)
        }
    }
}

