
import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
  name: "SSLaunchScreenPreview",
  targets: .app(
    name: "SSLaunchScreenPreview",
    testingOptions: [
    ],
    dependencies: [
      .feature(.sSLaunchScreen),
    ]
  )
)
