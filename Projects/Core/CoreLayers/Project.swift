
import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
  name: "CoreLayers",
  targets: .custom(
    name: "CoreLayers",
    product: .framework,
    dependencies: [
      .core(.sSPersistancy),
      .core(.sSNetwork),
      .thirdParty(.ComposableArchitecture),
      .core(.sSInterceptor),
      .core(.featureAction),
      .core(.sSRegexManager)
    ]
  )
)
