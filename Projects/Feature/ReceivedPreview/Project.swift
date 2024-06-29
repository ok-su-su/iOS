//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by MaraMincho on 6/3/24.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
  name: "ReceivedPreview",
  targets: .app(
    name: "ReceivedPreview",
    testingOptions: [
    ],
    dependencies: [
      .feature(.received),
    ]
  )
)
