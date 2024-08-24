//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by MaraMincho on 5/19/24.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
  name: "VotePreview",
  targets: .app(
    name: "VotePreview",
    testingOptions: [
    ],
    dependencies: [
      .feature(.vote),
    ]
  )
)
