
import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
  name: "MyPage",
  targets: .feature(
    .myPage,
    testingOptions: [.unitTest],
    dependencies: [
      .share(.shareLayer),
      .share(.sSLayout),
      .core(.coreLayers),
    ],
    testDependencies: []
  )
)
