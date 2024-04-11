
import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
  name: "Designsystem",
  targets: .custom(
    name: "Designsystem",
    product: .framework,
    infoPlist: [
      "UIAppFonts": [
        "Pretendard-Regular.otf"
      ],
    ],
    resources: "Resources/**"
  )
)
