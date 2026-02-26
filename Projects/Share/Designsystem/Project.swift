
import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
  name: "Designsystem",
  targets: .custom(
    name: "Designsystem",
    product: .framework,
    dependencies: [
      .thirdParty(.ComposableArchitecture),
      .thirdParty(.Lottie),
      .core(.sSNotification)
    ],
    infoPlist: [
      "UIAppFonts": [
        "Pretendard-Regular.otf",
        "Pretendard-Bold.otf",
      ],
    ],
    resources: "Resources/**"
  )
)
