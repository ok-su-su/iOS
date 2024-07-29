
import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
  name: "SSLogin",
  targets: .feature(
    .sSLogin,
    testingOptions: [.unitTest],
    dependencies: [
      .feature(.appleLogin),
      .feature(.kakaoLogin),
    ],
    testDependencies: []
  )
)
