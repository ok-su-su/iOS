
import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
  name: "FeatureAction",
  targets: .custom(
    name: "FeatureAction",
    product: .framework,
    dependencies: [
      .thirdParty(.ComposableArchitecture),
      .thirdParty(.SwiftAsyncMutex),
    ]
  )
)
