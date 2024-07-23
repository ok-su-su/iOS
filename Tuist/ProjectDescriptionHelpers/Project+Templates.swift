
import Foundation
import ProjectDescription

private let isCI = ProcessInfo.processInfo.environment["TUIST_CI"] != nil

public extension Project {
  static func makeModule(
    name: String,
    targets: [Target],
    packages: [Package] = []
  ) -> Project {
    let settingConfiguration: [Configuration] = [
      .debug(name: .debug, xcconfig: .relativeToXCConfig("Server/Debug")),
      .release(name: .release, xcconfig: .relativeToXCConfig("Server/Debug")),
    ]

    let settings: Settings = .settings(
      base: ["ASSETCATALOG_COMPILER_GENERATE_SWIFT_ASSET_SYMBOL_EXTENSIONS": "YES"],
      configurations: settingConfiguration
    )
    
    let options: Project.Options = .options(
      automaticSchemesOptions: .disabled,
      defaultKnownRegions: ["en", "ko"],
      developmentRegion: "ko",
      disableBundleAccessors: true,
      disableSynthesizedResourceAccessors: true
    )

    let schemes: [Scheme] = [.makeScheme(name: name)]

    return Project(
      name: name,
      organizationName: ProjectEnvironment.default.prefixBundleID,
      options: options,
      packages: packages,
      settings: settings,
      targets: targets,
      schemes: schemes
    )
  }
}

extension Scheme {
  /// Scheme을 만드는 메소드
  static func makeScheme(name: String) -> Scheme {
    return Scheme.scheme(
      name: name,
      shared: true,
      buildAction: .buildAction(targets: ["\(name)"]),
      testAction: .targets(
        ["\(name)Tests"],
        configuration: .debug,
        options: .options(coverage: true, codeCoverageTargets: ["\(name)"])
      ),
      runAction: .runAction(configuration: .debug),
      archiveAction: .archiveAction(configuration: .release),
      profileAction: .profileAction(configuration: .debug),
      analyzeAction: .analyzeAction(configuration: .debug)
    )
  }
}

public extension Path {
  static func relativeToXCConfig(_ path: String = "Shared") -> Path {
    print("XCConfig/\(path).xcconfig")
    return .relativeToRoot("XCConfig/\(path).xcconfig")
  }

  static func relativeToXCConfigString(_ path: String = "Shared") -> String {
    return "XCConfig/\(path).xcconfig"
  }
}
