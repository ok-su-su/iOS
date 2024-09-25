
import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
  name: "FeatureAction",
  targets: .custom(
    name: "FeatureAction",
    product: .framework,
    dependencies: [
      .core(.sSNotification),
      .thirdParty(.ComposableArchitecture),
      .thirdParty(.SwiftAsyncMutex),
      .core(.sSPersistancy),
    ]
  )
)
