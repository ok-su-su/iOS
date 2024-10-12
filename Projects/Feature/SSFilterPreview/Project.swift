
import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
  name: "SSFilterPreview",
  targets: .app(
    name: "SSFilterPreview",
    testingOptions: [
    ],
    dependencies: [
      .feature(.sSFilter),
    ]
  )
)
