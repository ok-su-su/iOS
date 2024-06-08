
import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
  name: "KakaoLogin",
  targets: .custom(
    name: "KakaoLogin",
    product: .framework,
    dependencies: [
      .thirdParty(.KakaoSDK),
    ]
  )
)
