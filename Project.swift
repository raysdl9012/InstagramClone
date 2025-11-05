import Foundation
import ProjectDescription

// MARK: - Base Settings

private let name = "InstagaramClone"
private let bundleIdentifier = "com.rsdl.project"
private let organization = "rsdl"

let baseSettings: SettingsDictionary = [:]



// MARK: - Project Definition
let project = Project(
    name: "\(name)",
    organizationName: "\(organization)", options: .options(
        automaticSchemesOptions: .enabled(
            codeCoverageEnabled: true
        )
    ),
    settings: .settings(
        base: getBasicSettings(),
        configurations: [
            .debug(name: "Debug",
                   settings: debugSettings(),
                   xcconfig: "Configuration/xcconfigs/Debug.xcconfig"),
            .debug(name: "Staging",
                   settings: stagingSettings(),
                   xcconfig: "Configuration/xcconfigs/Staging.xcconfig"),
            .release(name: "Release",
                     settings: releaseSettings(),
                     xcconfig: "Configuration/xcconfigs/Release.xcconfig")
        ]
    ),
    targets: [
        .target(
            name: "\(name)",
            destinations: .iOS,
            product: .app,
            bundleId: "\(bundleIdentifier)",
            infoPlist: .extendingDefault(
                with: getExtenseInfoPlist()
            ),
            buildableFolders: getBuildableFolders(),
            dependencies: []
        ),
        .target(
            name: "\(name)Tests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "\(bundleIdentifier)Tests",
            infoPlist: .default,
            buildableFolders: [
                .init(stringLiteral:"\(name)/Tests")
            ],
            dependencies: [
                .target(name: "\(name)")
            ]
        ),
    ],
    additionalFiles: [
        "README.md"
    ]
)

private func debugSettings() -> SettingsDictionary {
    let settings = baseSettings
    return settings
}

private func stagingSettings() -> SettingsDictionary {
    let settings = baseSettings
    return settings
}

private func releaseSettings() -> SettingsDictionary {
    let settings = baseSettings
    return settings
}

private func getBuildableFolders() -> [BuildableFolder] {
    [
        .init(stringLiteral: "\(name)/Sources"),
        .init(stringLiteral: "\(name)/Resources")
    ]
}

private func getBasicSettings() -> SettingsDictionary {
    [
        "CURRENT_PROJECT_VERSION": "0",
        "MARKETING_VERSION": "0.0.0",
        "DEVELOPMENT_TEAM": "WMB8HCJXS9",
        "ENABLE_USER_SCRIPT_SANDBOXING": "YES",
        "STRING_CATALOG_GENERATE_SYMBOLS": "NO",
        "ENABLE_ASSET_SYMBOL_GENERATOR": "YES",
        "ENABLE_STRING_CATALOG_SYMBOLS": "YES"
    ]
}

private func getExtenseInfoPlist() ->  [String : Plist.Value] {
    [
        "CFBundleDisplayName": "$(APP_DISPLAY_NAME)",
        "UILaunchStoryboardName": "LaunchScreen"
    ]
}
