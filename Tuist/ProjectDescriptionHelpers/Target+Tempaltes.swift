//
//  Target+Templates.swift
//  ProjectDescriptionHelpers
//
//  Created by MaraMincho on 1/26/24.
//
import ProjectDescription

// MARK: - TestingOption

public enum TestingOption {
  case unitTest
  case uiTest
}

public extension [Target] {
  /// App으로 실행가능한 모듈을 만들 때 사용합니다.
  /// - Parameters:
  ///   - name: App Target 이름
  ///   - testingOptions: App Target에서 추가할 테스트 옵션들
  ///   - dependencies: App의 의존성
  ///   - testDependencies: App에서 만들어지는 테스트 모듈의 의존성. `testingOptions`파라미터가 nil이 아닐 때 유효합니다.
  ///   - infoPlist: App에서 설정할 infoPlist
  static func app(
    name: String,
    productName: String? = nil,
    testingOptions: Set<TestingOption> = [],
    entitlements: Entitlements? = nil,
    dependencies: [TargetDependency] = [],
    testDependencies: [TargetDependency] = [],
    infoPlist: [String: Plist.Value] = [:],
    additionalScripts: [TargetScript] = []
  ) -> [Target] {
    
    // 에셋 리소스를 코드로 자동완성 해주는 옵션 활성화
    let settings: Settings = .settings(
      base: [
        "DEVELOPMENT_TEAM": "2G5Z92682P",
        "ENABLE_USER_SCRIPT_SANDBOXING": "No", // SandBoxingError
        "ENABLE_MODULE_VERIFIER": "No", // Enable module Verifier
        "MODULE_VERIFIER_SUPPORTED_LANGUAGES": "No",
        "DEBUG_INFORMATION_FORMAT": "dwarf-with-dsym", // For Firebase
        "OTHER_LDFLAGS": "-ObjC", // For Firebase ,
        "SOME_BASE_FLAG": .string("value"),
//        "CLANG_ENABLE_MODULES": "Yes"
      ],
      configurations: [
        .debug(name: .debug),
        .release(name: .release),
      ]
    )
    
    let mergedInfoPlist: [String: Plist.Value] = [
      "BaseURL": "$(BASE_URL)",
      "UILaunchStoryboardName": "LaunchScreen",
      "UIApplicationSceneManifest": [
        "UIApplicationSupportsMultipleScenes": false,
      ],
//      "UIBackgroundModes": [
//        "fetch",
//        "location",
//        "processing",
//        "remote-notification",
//      ],
    ].merging(infoPlist) { _, new in
      new
    }

    var targets: [Target] = [
      Target.target(
        name: name,
        destinations: [.iPhone],
        product: .app,
        productName: productName,
        bundleId: "\(ProjectEnvironment.default.prefixBundleID).\(name.lowercased()).app",
        deploymentTargets: ProjectEnvironment.default.deploymentTargets,
        infoPlist: .extendingDefault(with: mergedInfoPlist),
        sources: "Sources/**",
        resources: "Resources/**",
        entitlements: entitlements,
        scripts: [.swiftFormat, .swiftLint] + additionalScripts,
        dependencies: dependencies,
        settings: .default,
        environmentVariables: ["IDEPreferLogStreaming": "YES"]
      ),
    ]

    if testingOptions.contains(.unitTest) {
      targets.append(
        Target.target(
          name: "\(name)Tests",
          destinations: [.iPhone],
          product: .unitTests,
          bundleId: "\(ProjectEnvironment.default.prefixBundleID).\(name.lowercased())Tests",
          deploymentTargets: ProjectEnvironment.default.deploymentTargets,
          infoPlist: .default,
          sources: "Tests/**",
          scripts: [.swiftLint, .swiftFormat] + additionalScripts,
          dependencies: testDependencies + [.target(name: name)],
          settings: .default
        )
      )
    }
    if testingOptions.contains(.uiTest) {
      targets.append(
        Target.target(
          name: "\(name)UITests",
          destinations: [.iPhone],
          product: .uiTests,
          bundleId: "\(ProjectEnvironment.default.prefixBundleID).\(name.lowercased())UITests",
          deploymentTargets: ProjectEnvironment.default.deploymentTargets,
          infoPlist: .default,
          sources: "UITests/**",
          scripts: [.swiftLint, .swiftFormat] + additionalScripts,
          dependencies: testDependencies + [.target(name: name)],
          settings: .default
        )
      )
    }

    return targets
  }

  /// Feature 모듈의 `Target`을 생성합니다.
  /// - Parameters:
  ///   - feature: Feature Module
  ///   - testingOptions: Feature에서 추가할 테스트 옵션들
  ///   - dependencies: Feature의 의존성
  ///   - testDependencies: Feature에서 만들어지는 테스트들의 의존성. `testingOptions`파라미터가 nil이 아닐 때 유효합니다.
  ///   - infoPlist: Feature에서 설정할 infoPlist
  ///   - resources: 리소스 사용 경로, 기본값은 nil입니다. 만약 사용하고 싶다면 경로를 지정해주세요.
  /// - Returns: Feature 모듈의 Target 리스트
  static func feature(
    _ feature: Feature,
    product: Product = .framework,
    testingOptions: Set<TestingOption> = [],
    dependencies: [TargetDependency] = [],
    testDependencies: [TargetDependency] = [],
    infoPlist: [String: Plist.Value] = [:],
    additionalScripts: [TargetScript] = [],
    resources: ResourceFileElements? = nil
  ) -> [Target] {
    let mergedInfoPlist: [String: Plist.Value] = ["BaseURL": "$(BASE_URL)"].merging(infoPlist) { _, new in
      new
    }

    // 에셋 리소스를 코드로 자동완성 해주는 옵션 활성화
    let settings: Settings = .settings(
      base: [
        "ASSETCATALOG_COMPILER_GENERATE_SWIFT_ASSET_SYMBOL_EXTENSIONS": "YES",
        "ENABLE_USER_SCRIPT_SANDBOXING": "No", // SandBoxingError
        "ENABLE_MODULE_VERIFIER": "No", // Enable module Verifier
        "MODULE_VERIFIER_SUPPORTED_LANGUAGES": "No",
        "DEBUG_INFORMATION_FORMAT": "dwarf-with-dsym", // For Firebase
        "OTHER_LDFLAGS": "-ObjC" // For Firebase
//        "CLANG_ENABLE_MODULES": "Yes"
//        "BUILD_LIBRARY_FOR_DISTRIBUTION": "No" // Enable module Verifier
      ],
      configurations: [
        .debug(name: .debug),
        .release(name: .release),
      ]
    )

    var targets: [Target] = [
      Target.target(
        name: "\(feature.targetName)",
        destinations: [.iPhone],
        product: product,
        bundleId: "\(ProjectEnvironment.default.prefixBundleID).\(feature.targetName)",
        deploymentTargets: ProjectEnvironment.default.deploymentTargets,
        infoPlist: .extendingDefault(with: mergedInfoPlist),
        sources: "Sources/**",
        resources: resources,
        scripts: [.swiftFormat, .swiftLint] + additionalScripts,
        dependencies: dependencies,
        settings: .default
      ),
    ]

    if testingOptions.contains(.unitTest) {
      targets.append(
        Target.target(
          name: "\(feature.targetName)FeatureTests",
          destinations: [.iPhone],
          product: .unitTests,
          bundleId: "\(ProjectEnvironment.default.prefixBundleID).\(feature.targetName)FeatureTests",
          deploymentTargets: ProjectEnvironment.default.deploymentTargets,
          sources: "Tests/**",
          scripts: [.swiftLint, .swiftFormat] + additionalScripts,
          dependencies: testDependencies + [.target(name: "\(feature.targetName)")],
          settings: .default
        )
      )
    }

    if testingOptions.contains(.uiTest) {
      targets.append(
        Target.target(
          name: "\(feature.targetName)FeatureUITests",
          destinations: [.iPhone],
          product: .uiTests,
          bundleId: "\(ProjectEnvironment.default.prefixBundleID).\(feature.targetName)FeatureUITests",
          deploymentTargets: ProjectEnvironment.default.deploymentTargets,
          sources: "UITests/**",
          scripts: [.swiftLint, .swiftFormat] + additionalScripts,
          dependencies: testDependencies + [.target(name: "\(feature.targetName)")],
          settings: .default
        )
      )
    }

    return targets
  }

  /// Target을 사용자화하여 생성합니다. 보통 사용자에게 View가 없는 기능들을 정의할 때 쓰입니다.
  ///
  /// DesignSystem, Custom Network Layer 등 다양한 target들을 만들 때 쓰입니다.
  /// - Parameters:
  ///   - name: Target 이름
  ///   - product: Target Product
  ///   - testingOptions: Target에서 추가할 테스트 옵션들
  ///   - dependencies: Target의 의존성
  ///   - testDependencies: Target의 테스트 모듈의 의존성. `testingOptions`파라미터가 nil이 아닐 때 유효합니다.
  ///   - infoPlist: Target에서 설정할 infoPlist
  ///   - resources: 리소스 사용 경로, 기본값은 nil입니다. 만약 사용하고 싶다면 경로를 지정해주세요.
  ///   - settings: Target settings configuration
  static func custom(
    name: String,
    product: Product,
    testingOptions: Set<TestingOption> = [],
    dependencies: [TargetDependency] = [],
    testDependencies: [TargetDependency] = [],
    infoPlist: [String: Plist.Value] = [:],
    resources: ResourceFileElements? = nil,
    additionalScripts: [TargetScript] = [],
    settings: Settings? = nil,
    additionalFiles: [FileElement] = []
  ) -> [Target] {
    let mergedInfoPlist: [String: Plist.Value] = ["BaseURL": "$(BASE_URL)"].merging(infoPlist) { _, new in
      new
    }

    var targets: [Target] = [
      Target.target(
        name: "\(name)",
        destinations: [.iPhone],
        product: product,
        bundleId: "\(ProjectEnvironment.default.prefixBundleID).\(name)",
        deploymentTargets: ProjectEnvironment.default.deploymentTargets,
        infoPlist: .extendingDefault(with: mergedInfoPlist),
        sources: "Sources/**",
        resources: resources,
        scripts: [.swiftFormat, .swiftLint] + additionalScripts,
        dependencies: dependencies,
        settings: .default,
        additionalFiles: additionalFiles
      ),
    ]

    if testingOptions.contains(.unitTest) {
      targets.append(
        Target.target(
          name: "\(name)Tests",
          destinations: [.iPhone],
          product: .unitTests,
          bundleId: "\(ProjectEnvironment.default.prefixBundleID).\(name)FeatureTests",
          deploymentTargets: ProjectEnvironment.default.deploymentTargets,
          sources: "Tests/**",
          scripts: [],
          dependencies: testDependencies + [.target(name: name)],
          settings: .default
        )
      )
    }

    if testingOptions.contains(.uiTest) {
      targets.append(
        Target.target(
          name: "\(name)UITests",
          destinations: [.iPhone],
          product: .uiTests,
          bundleId: "\(ProjectEnvironment.default.prefixBundleID).\(name)FeatureUITests",
          deploymentTargets: ProjectEnvironment.default.deploymentTargets,
          sources: "UITests/**",
          scripts: [],
          dependencies: testDependencies + [.target(name: name)],
          settings: .default
        )
      )
    }

    return targets
  }
}
