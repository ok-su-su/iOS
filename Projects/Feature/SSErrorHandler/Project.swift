
import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
  name: "SSErrorHandler",
  targets: .feature(
    .sSErrorHandler,
    product: .framework,
    testingOptions: [],
    dependencies: [
      .core(.coreLayers),
    ],
    testDependencies: [],
    infoPlist: ["DISCORD_WEB_HOOK_URL": "$(DISCORD_WEB_HOOK_URL"]
  )
)
