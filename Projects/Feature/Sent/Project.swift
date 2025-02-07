
import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
  name: "Sent",
  targets: .feature(
    .sent,
    testingOptions: [.unitTest],
    dependencies: [
      .core(.coreLayers),
      .share(.shareLayer),
      .share(.sSLayout),
      .feature(.sSSearch),
      .feature(.sSSelectableItems),
      .feature(.sSCreateEnvelope),
      .feature(.sSEnvelope),
      .feature(.sSFilter),
    ],
    testDependencies: []
  )
)
