
import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
  name: "SSEnvelopePreview",
  targets: .app(
    name: "SSEnvelopePreview",
    testingOptions: [
    ],
    dependencies: [
      .feature(.sSEnvelope),
    ]
  )
)
