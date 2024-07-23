
import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
  name: "SSInterceptor",
  targets: .custom(
    name: "SSInterceptor",
    product: .framework,
    dependencies: [
      .core(.sSNetwork),
      .core(.sSPersistancy),
    ]
  )
)
