
import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
  name: "MyPage",
  targets: .feature(
    .myPage,
    testingOptions: [.unitTest],
    dependencies: [
      .share(.designsystem),
      .share(.sSAlert),
      .share(.sSLayout),
      .core(.coreLayers),
    ],
    testDependencies: []
  )
)
