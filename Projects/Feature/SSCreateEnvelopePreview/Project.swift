
import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
  name: "SSCreateEnvelopePreview",
  targets: .app(
    name: "SSCreateEnvelopePreview",
    testingOptions: [
    ],
    dependencies: [
      .feature(.sSCreateEnvelope),
    ]
  )
)
