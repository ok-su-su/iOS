
import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
  name: "SSFirebase",
  targets: .custom(
    name: "SSFirebase",
    product: .framework,
    dependencies: [
//      .thirdParty(.FirebaseAnalytics),
//      .thirdParty(.FirebaseCrashlytics)
    ],
    resources: "Resources/**"
  )
)

