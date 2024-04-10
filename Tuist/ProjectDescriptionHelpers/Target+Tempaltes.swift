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
    testingOptions: Set<TestingOption> = [],
    entitlements: Entitlements? = nil,
    dependencies: [TargetDependency] = [],
    testDependencies: [TargetDependency] = [],
    infoPlist: [String: Plist.Value] = [:]
  ) -> [Target] {
    let mergedInfoPlist: [String: Plist.Value] = [
      "BaseURL": "$(BASE_URL)",
      "UILaunchStoryboardName": "LaunchScreen",
      "UIApplicationSceneManifest": [
        "UIApplicationSupportsMultipleScenes": false,
//        "UISceneConfigurations": [
//          "UIWindowSceneSessionRoleApplication": [
//            [
//              "UISceneConfigurationName": "Default Configuration",
//              "UISceneDelegateClassName": "$(PRODUCT_MODULE_NAME).SceneDelegate",
//            ],
//          ],
//        ],
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
        destinations: .iOS,
        product: .app,
        bundleId: "\(ProjectEnvironment.default.prefixBundleID).\(name.lowercased())",
        deploymentTargets: ProjectEnvironment.default.deploymentTargets,
        infoPlist: .extendingDefault(with: mergedInfoPlist),
        sources: "Sources/**",
        resources: "Resources/**",
        entitlements: entitlements,
        scripts: [.swiftFormat, .swiftLint],
        dependencies: dependencies
      ),
    ]

    if testingOptions.contains(.unitTest) {
      targets.append(
        Target.target(
          name: "\(name)Tests",
          destinations: .iOS,
          product: .unitTests,
          bundleId: "\(ProjectEnvironment.default.prefixBundleID).\(name.lowercased())Tests",
          sources: "Tests/**",
          scripts: [.swiftLint, .swiftFormat],
          dependencies: testDependencies + [.target(name: name)]
        )
      )
    }
    if testingOptions.contains(.uiTest) {
      targets.append(
        Target.target(
          name: "\(name)UITests",
          destinations: .iOS,
          product: .unitTests,
          bundleId: "\(ProjectEnvironment.default.prefixBundleID).\(name.lowercased())UITests",
          sources: "UITests/**",
          scripts: [.swiftLint, .swiftFormat],
          dependencies: testDependencies + [.target(name: name)]
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
    resources: ResourceFileElements? = nil
  ) -> [Target] {
    let mergedInfoPlist: [String: Plist.Value] = ["BaseURL": "$(BASE_URL)"].merging(infoPlist) { _, new in
      new
    }

    // 에셋 리소스를 코드로 자동완성 해주는 옵션 활성화
    let settings: Settings = .settings(
      base: ["ASSETCATALOG_COMPILER_GENERATE_SWIFT_ASSET_SYMBOL_EXTENSIONS": "YES"],
      configurations: [
        .debug(name: .debug),
        .release(name: .release),
      ]
    )

    var targets: [Target] = [
      Target.target(
        name: "\(feature.targetName)",
        destinations: .iOS,
        product: product,
        bundleId: "\(ProjectEnvironment.default.prefixBundleID).\(feature.targetName)",
        deploymentTargets: ProjectEnvironment.default.deploymentTargets,
        infoPlist: .extendingDefault(with: mergedInfoPlist),
        sources: "Sources/**",
        resources: resources,
        scripts: [.swiftFormat, .swiftLint],
        dependencies: dependencies,
        settings: settings
      ),
    ]

    if testingOptions.contains(.unitTest) {
      targets.append(
        Target.target(
          name: "\(feature.targetName)FeatureTests",
          destinations: .iOS,
          product: .unitTests,
          bundleId: "\(ProjectEnvironment.default.prefixBundleID).\(feature.targetName)FeatureTests",
          sources: "Tests/**",
          scripts: [.swiftLint, .swiftFormat],
          dependencies: testDependencies + [.target(name: "\(feature.targetName)")]
        )
      )
    }

    if testingOptions.contains(.uiTest) {
      targets.append(
        Target.target(
          name: "\(feature.targetName)FeatureUITests",
          destinations: .iOS,
          product: .unitTests,
          bundleId: "\(ProjectEnvironment.default.prefixBundleID).\(feature.targetName)FeatureUITests",
          sources: "UITests/**",
          scripts: [.swiftLint, .swiftFormat],
          dependencies: testDependencies + [.target(name: "\(feature.targetName)")]
        )
      )
    }

    return targets
  }

  /// Target을 사용자화하여 생성합니다.
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
    settings: Settings? = nil
  ) -> [Target] {
    let mergedInfoPlist: [String: Plist.Value] = ["BaseURL": "$(BASE_URL)"].merging(infoPlist) { _, new in
      new
    }

    var targets: [Target] = [
      Target.target(
        name: "\(name)",
        destinations: .iOS,
        product: product,
        bundleId: "\(ProjectEnvironment.default.prefixBundleID).\(name)",
        deploymentTargets: ProjectEnvironment.default.deploymentTargets,
        infoPlist: .extendingDefault(with: mergedInfoPlist),
        sources: "Sources/**",
        resources: resources,
        scripts: [.swiftFormat, .swiftLint],
        dependencies: dependencies,
        settings: settings
      ),
    ]

    if testingOptions.contains(.unitTest) {
      targets.append(
        Target.target(
          name: "\(name)Tests",
          destinations: .iOS,
          product: .unitTests,
          bundleId: "\(ProjectEnvironment.default.prefixBundleID).\(name)FeatureTests",
          sources: "Tests/**",
          scripts: [],
          dependencies: testDependencies + [.target(name: name)]
        )
      )
    }

    if testingOptions.contains(.uiTest) {
      targets.append(
        Target.target(
          name: "\(name)UITests",
          destinations: .iOS,
          product: .unitTests,
          bundleId: "\(ProjectEnvironment.default.prefixBundleID).\(name)FeatureUITests",
          sources: "UITests/**",
          scripts: [],
          dependencies: testDependencies + [.target(name: name)]
        )
      )
    }

    return targets
  }
}
