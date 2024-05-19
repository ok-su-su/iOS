
import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
  name: "SSToastPreview",
  targets: .app(
    name: "SSToastPreview",
    testingOptions: [
      .uiTest
    ],
    dependencies: [
      .share(.sSToast)
    ],
    testDependencies: [
      .share(.sSToast)
    ]
  )
)
