//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by MaraMincho on 6/28/24.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
  name: "MyPagePreview",
  targets: .app(
    name: "MyPagePreview",
    testingOptions: [
    ],
    dependencies: [
      .feature(.myPage),
    ]
  )
)
