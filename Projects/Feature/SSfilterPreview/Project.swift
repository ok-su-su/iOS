
import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
  name: "SSfilterPreview",
  targets: .app(
    name: "SSfilterPreview",
    testingOptions: [
    ],
    dependencies: [
      .feature(.sSfilter),
    ]
  )
)
