
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
    testDependencies: [],
    infoPlist: [
      "PRIVACY_POLICY_URL": "$(PRIVACY_POLICY_URL)",
      "SUSU_GOOGLE_FROM_URL": "$(SUSU_GOOGLE_FROM_URL)",
    ]
  )
)
