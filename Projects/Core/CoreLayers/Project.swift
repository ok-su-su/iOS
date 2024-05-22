
import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
  name: "CoreLayers",
  targets: .custom(
    name: "CoreLayers",
    product: .framework,
    dependencies: [
      //      .core(.sSDataBase),
      .core(.sSNetwork),
      .thirdParty(.ComposableArchitecture),
    ]
  )
)
