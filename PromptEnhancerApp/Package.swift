// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "PromptEnhancerApp",
    platforms: [
        .macOS(.v13)
    ],
    products: [
        .executable(name: "PromptEnhancerApp", targets: ["PromptEnhancerApp"])
    ],
    targets: [
        .executableTarget(
            name: "PromptEnhancerApp",
            dependencies: [],
            path: "Sources",
            linkerSettings: [
                .linkedFramework("Carbon")
            ]
        )
    ]
)
