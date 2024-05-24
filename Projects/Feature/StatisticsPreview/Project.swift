//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by MaraMincho on 5/24/24.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
  name: "StatisticsPreview",
  targets: .app(
    name: "StatisticsPreview",
    testingOptions: [
    ],
    dependencies: [
      .feature(.statistics),
    ]
  )
)
