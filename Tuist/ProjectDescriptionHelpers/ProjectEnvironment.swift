//
//  ProjectEnvironment.swift
//  Packages
//
//  Created by MaraMincho on 4/8/24.
//

import ProjectDescription
public struct ProjectEnvironment {
  public let appName: String
  public let targetName: String
  public let prefixBundleID: String
  public let deploymentTargets: DeploymentTargets
  public let baseSetting: SettingsDictionary

  private init(appName: String, targetName: String, prefixBundleID: String, deploymentTargets: DeploymentTargets, baseSetting: SettingsDictionary) {
    self.appName = appName
    self.targetName = targetName
    self.prefixBundleID = prefixBundleID
    self.deploymentTargets = deploymentTargets
    self.baseSetting = baseSetting
  }

  public static var `default`: ProjectEnvironment {
    ProjectEnvironment(
      appName: "susu",
      targetName: "susu",
      prefixBundleID: "com.oksusu",
      deploymentTargets: .iOS("17.0"),
      baseSetting: [:]
    )
  }
}
