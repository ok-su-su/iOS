
import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
  name: "SSErrorHandler",
  targets: .feature(
    .sSErrorHandler,
    testingOptions: [],
    dependencies: [
      .core(.sSNotification),
    ],
    testDependencies: [],
    infoPlist: ["DISCORD_WEB_HOOK_URL": "$(DISCORD_WEB_HOOK_URL"]
  )
)
