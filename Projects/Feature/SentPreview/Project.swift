//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by MaraMincho on 6/19/24.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
  name: "SentPreview",
  targets: .app(
    name: "SentPreview",
    testingOptions: [
    ],
    dependencies: [
      .feature(.sent),
    ]
  )
)
