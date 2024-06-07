
import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
  name: "ShareLayer",
  targets: .custom(
    name: "ShareLayer",
    product: .framework,
    dependencies: [
      .share(.designsystem),
      .share(.sSAlert),
      .share(.sSBottomSelectSheet),
      .share(.sSToast),
    ]
  )
)
