
import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
  name: "Onboarding",
  targets: .feature(
    .onboarding,
    testingOptions: [.unitTest],
    dependencies: [
      .share(.shareLayer),
      .core(.coreLayers),
    ],
    testDependencies: []
  )
)
