// swift-tools-version: 5.9
import Foundation
import PackageDescription

// Find the shared/ios frameworks directory from the package directory path.
// Three supported layouts:
//   Dev:              .../frameworks/flutter/<plugin>/ios/<package>
//                     → .../frameworks/shared/ios
//   Archive:          .../<archive-root>/<plugin>/ios/<package>
//                     → .../<archive-root>/shared/ios  (3 levels up)
//   Integration test: .../build/_build/flutter/tmp/[<plugin>/ios/<package>
//                     OR samples/.../<app>/ios/Flutter/<package>]
//                     → .../tmp/frameworks/shared/ios
// No file system access used (avoids SPM sandbox restrictions).
func findSharedFrameworksPath() -> String? {
    let packageDir = Context.packageDirectory

    // Integration test build layout: path passes through /flutter/tmp/
    // Shared frameworks are at tmp/frameworks/shared/ios
    if let range = packageDir.range(of: "/flutter/tmp/") {
        return String(packageDir[..<range.upperBound]) + "frameworks/shared/ios"
    }

    // Dev repo layout: path contains /frameworks/flutter/
    // Shared frameworks are at .../frameworks/shared/ios
    if let range = packageDir.range(of: "/frameworks/flutter/") {
        return String(packageDir[..<range.lowerBound]) + "/frameworks/shared/ios"
    }

    // Archive layout: <archive-root>/<plugin>/ios/<package> — go up 3 levels
    var base = packageDir as NSString
    for _ in 0..<3 {
        base = base.deletingLastPathComponent as NSString
    }
    return base.appendingPathComponent("shared/ios")
}

// Read version from pubspec.yaml
func getVersion() -> String {
    let pubspecPath = Context.packageDirectory + "/../../pubspec.yaml"
    guard let content = try? String(contentsOfFile: pubspecPath, encoding: .utf8) else {
        fatalError("Could not read pubspec.yaml at \(pubspecPath)")
    }

    // Parse version line (format: "version: X.Y.Z")
    let lines = content.components(separatedBy: .newlines)
    for line in lines {
        let trimmed = line.trimmingCharacters(in: .whitespaces)
        if trimmed.hasPrefix("version:") {
            let versionString =
                trimmed
                .replacingOccurrences(of: "version:", with: "")
                .trimmingCharacters(in: .whitespaces)
            return versionString
        }
    }

    fatalError("Could not find version in pubspec.yaml at \(pubspecPath)")
}

let version = getVersion()

// Configure dependencies based on environment
// Automatically use local path if it exists, otherwise use published package
var dependencies: [Package.Dependency] = []

let coreFrameworksPath = findSharedFrameworksPath().map { "\($0)/scandit-datacapture-frameworks-core" }

if let localPath = coreFrameworksPath {
    dependencies.append(.package(path: localPath))
} else {
    dependencies.append(
        .package(
            url: "https://github.com/Scandit/scandit-datacapture-frameworks-core.git",
            exact: Version(stringLiteral: version)
        )
    )
}

let package = Package(
    name: "scandit_flutter_datacapture_core",
    platforms: [.iOS(.v15)],
    products: [
        .library(
            name: "scandit-flutter-datacapture-core",
            targets: ["scandit_flutter_datacapture_core"]
        )
    ],
    dependencies: dependencies,
    targets: [
        .target(
            name: "scandit_flutter_datacapture_core",
            dependencies: [
                .product(name: "ScanditFrameworksCore", package: "scandit-datacapture-frameworks-core")
            ],
            path: "Sources/scandit_flutter_datacapture_core"
        )
    ]
)
