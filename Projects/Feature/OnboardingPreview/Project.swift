
import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
  name: "OnboardingPreview",
  targets: .app(
    name: "OnboardingPreview",
    testingOptions: [
    ],
    dependencies: [
      .feature(.onboarding),
    ]
  )
)
