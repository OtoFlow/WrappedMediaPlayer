import ProjectDescription

let project = Project(
    name: "WrappedMediaPlayer",
    targets: [
        .target(
            name: "WrappedMediaPlayer",
            destinations: .iOS,
            product: .framework,
            bundleId: "WrappedMediaPlayer",
            deploymentTargets: .iOS("16.0"),
            sources: ["Sources/**"],
            dependencies: [
                .external(name: "MPVKit"),
            ]
        )
    ]
)
