
import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
  name: "SSNetwork",
  targets: .custom(
    name: "SSNetwork",
    product: .framework,
    testingOptions: [.unitTest],
    dependencies: [
      .thirdParty(.Moya),
      .core(.sSPersistancy),
    ]
  )
)
