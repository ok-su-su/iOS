// swift-tools-version: 5.9
import PackageDescription

#if TUIST
import ProjectDescription

let packageSettings = PackageSettings(
  // Customize the product types for specific package product
  // Default is .staticFramework
  // productTypes: ["Alamofire": .framework,]
  productTypes: [:]
)
#endif

let package = Package(
  name: "IOS",
  dependencies: [
    .package(url: "https://github.com/Alamofire/Alamofire.git", exact: "5.9.1")
    // You can read more about dependencies here: https://docs.tuist.io/documentation/tuist/dependencies
  ]
)
