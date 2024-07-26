
import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
  name: "SSFirebase",
  targets: .custom(
    name: "SSFirebase",
    product: .staticLibrary,
    dependencies: [
      .external(name: "FirebaseAnalytics"),
      .external(name: "FirebaseCrashlytics"),
    ]
//    additionalScripts: [.firebase]
  )
)
