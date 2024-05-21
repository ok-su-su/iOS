//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by MaraMincho on 5/19/24.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
  name: "SSVotePreview",
  targets: .app(
    name: "SSVotePreview",
    testingOptions: [
    ],
    dependencies: [
      .feature(.vote),
    ]
  )
)
