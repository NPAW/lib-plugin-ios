// swift-tools-version:5.1
import PackageDescription

let package = Package(
    name: "YouboraLib",
    platforms: [
        .iOS(.v9),
        .tvOS(.v9),
        .macOS(.v10_10)
    ],
    products: [
        .library(
          name: "YouboraLib", 
          targets: [
            "YouboraLib iOS",
          ]),
    ],
    dependencies: [],
    targets: [
        .target(
          name: "YouboraLib iOS",
           dependencies: [], 
           path: "./YouboraLib"
           )
    ]
)