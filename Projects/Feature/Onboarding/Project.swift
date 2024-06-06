
import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
  name: "Onboarding",
  targets: .feature(
    .onboarding,
    testingOptions: [.unitTest],
    dependencies: [
      .share(.designsystem),
      .share(.sSAlert),
      .share(.sSLayout),
      .core(.coreLayers),
      .share(.sSToast),
    ],
    testDependencies: []
  )
)
