

import Foundation
import ProjectDescription

private let tuistRootDirectory = ProcessInfo.processInfo.environment["TUIST_ROOT_DIR"]

private func swiftFormatCommand() -> String {
  if let tuistRootDirectory {
    return "swiftformat . --config \(tuistRootDirectory)/.swiftformat"
  } else {
    return "swiftformat ."
  }
}

private func swiftLintCommand() -> String {
  if let tuistRootDirectory {
    return "swiftlint --config \(tuistRootDirectory)/.swiftlint.yml"
  } else {
    return "swiftlint"
  }
}

public extension TargetScript {
  static let swiftFormat: Self = .pre(
    script: """
      export PATH="$PATH:/opt/homebrew/bin"
      if which swiftformat > /dev/null; then
          if [ "${ENABLE_PREVIEWS}" = "YES" ]; then
              echo "Not running Swift Format for Xcode Previews"
              exit 0;
          fi
          \(swiftFormatCommand())
      else
          echo "warning: SwiftFormat not installed, download from https://github.com/nicklockwood/SwiftFormat"
      fi
    """,
    name: "SwiftFormat Run Script",
    basedOnDependencyAnalysis: false
  )

  static var swiftLint: Self = .post(
    script: """
      export PATH="$PATH:/opt/homebrew/bin"
      if which swiftlint > /dev/null; then
          \(swiftLintCommand())
      else
          echo "warning: SwiftLint not installed, download from https://github.com/realm/SwiftLint"
      fi
    """,
    name: "SwiftLint Run Script",
    basedOnDependencyAnalysis: false
  )
}
