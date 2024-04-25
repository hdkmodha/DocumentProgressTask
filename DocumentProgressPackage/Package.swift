// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

extension Target.Dependency {
    static var tca: Self {
        .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
    }
}

let package = Package(
    name: "DocumentProgressPackage",
    platforms: [.iOS(.v17)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "OnboardingFeature",
            targets: ["OnboardingFeature"]
        ),
        .library(
            name: "UIUtilities",
            targets: ["UIUtilities"]
        ),
    ],
    dependencies: [
        .package(
            url: "https://github.com/pointfreeco/swift-composable-architecture",
            branch: "shared-state-beta"
        )
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(name: "UIUtilities"),
        .target(
            name: "DocumentProgressPackage"),
        .target(
            name: "OnboardingSelectPhotoFeature",
            dependencies: [
                .tca,
                "UIUtilities"
            ]
        ),
        .target(
            name: "OnboardingPhoneNumberFeature",
            dependencies: [
                .tca,
                "UIUtilities"
            ]
        ),
        .target(
            name: "OnboardingSelectCountryFeature",
            dependencies: [
                .tca,
                "UIUtilities"
            ]
        ),
        .target(
            name: "OnboardingFeature",
            dependencies: [
                .tca,
                "UIUtilities",
                "OnboardingSelectPhotoFeature",
                "OnboardingPhoneNumberFeature",
                "OnboardingSelectCountryFeature",
            ]
        ),
        .testTarget(
            name: "DocumentProgressPackageTests",
            dependencies: ["DocumentProgressPackage"]),
    ]
)
