// swift-tools-version: 5.9
import PackageDescription

#if TUIST
import ProjectDescription
import ProjectDescriptionHelpers

let packageSettings = PackageSettings(
  // Customize the product types for specific package product
  // Default is .staticFramework
  // productTypes: ["Alamofire": .framework,]
  productTypes: ThirdParty.allCasesProductType
)
#endif

let package = Package(
  name: "IOS",
  dependencies: [
    .package(url: "https://github.com/Moya/Moya.git", exact: "15.0.3"),
    .package(url: "https://github.com/pointfreeco/swift-composable-architecture", exact: "1.9.2")
  ]
)


