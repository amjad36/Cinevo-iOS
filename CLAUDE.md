# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project

`Cinevo-iOS` — a SwiftUI iOS app, currently at the template stage (an app target plus unit- and UI-test targets). Built from a plain `.xcodeproj`; there is no workspace, no SPM manifest, and no third-party dependencies.

## Commands

The scheme `Cinevo-iOS` is shared (`Cinevo-iOS.xcodeproj/xcshareddata/xcschemes/`) and covers build, run, and both test bundles.

```bash
# Build for the simulator
xcodebuild -project Cinevo-iOS.xcodeproj -scheme Cinevo-iOS \
  -sdk iphonesimulator -destination 'generic/platform=iOS Simulator' build

# Run all tests
xcodebuild -project Cinevo-iOS.xcodeproj -scheme Cinevo-iOS \
  -destination 'platform=iOS Simulator,name=iPhone 16' test

# Run a single test (-only-testing:<bundle>/<class>/<method>)
xcodebuild -project Cinevo-iOS.xcodeproj -scheme Cinevo-iOS \
  -destination 'platform=iOS Simulator,name=iPhone 16' \
  -only-testing:Cinevo-iOSTests/Cinevo_iOSTests/testExample test

# Skip the UI-test bundle (it boots the app, so it is much slower)
... -skip-testing:Cinevo-iOSUITests test
```

Adjust `name=iPhone 16` to a simulator that exists locally (`xcrun simctl list devices available`).

## Xcode-version compatibility (important)

This project is deliberately pinned to the **Xcode 14 project format** so it can be opened by older Xcode versions as well as current ones. It was downgraded from the Xcode 27 format, which older Xcode refuses with "it is in a future Xcode project file format."

Do not reintroduce newer-Xcode constructs. Specifically:

- `project.pbxproj` keeps `objectVersion = 56` and `compatibilityVersion = "Xcode 14.0"`. Opening the project in a modern Xcode and letting it "update to recommended settings" will bump this and break older Xcode again — decline that prompt.
- Source files are listed **explicitly** as `PBXFileReference` / `PBXBuildFile` entries in `PBXGroup`s and build phases. Do not convert to `PBXFileSystemSynchronizedRootGroup` (Xcode 16+), which is why new files must be registered in the pbxproj rather than just dropped on disk.
- Deployment target is `IPHONEOS_DEPLOYMENT_TARGET = 16.0` across all targets. APIs newer than iOS 16 need `@available` / `if #available` guards.
- Unit tests use **XCTest**, not Swift Testing (`import Testing`, `@Test`, `#expect` require Xcode 16+).
- SwiftUI previews use `PreviewProvider`, not the `#Preview` macro (Xcode 15+).
- `AppIcon.appiconset` holds a single 1024×1024 universal entry; the dark/tinted `appearances` variants are Xcode 15+.
- Avoid the build settings that were stripped for this reason: `SWIFT_APPROACHABLE_CONCURRENCY`, `SWIFT_DEFAULT_ACTOR_ISOLATION`, `SWIFT_UPCOMING_FEATURE_MEMBER_IMPORT_VISIBILITY`, `STRING_CATALOG_GENERATE_SYMBOLS`, `LOCALIZATION_PREFERS_STRING_CATALOGS`, `ASSETCATALOG_COMPILER_GENERATE_SWIFT_ASSET_SYMBOL_EXTENSIONS`.

## Naming

The directory and target names are hyphenated (`Cinevo-iOS`), so the Swift module name is `Cinevo_iOS` — that is the spelling used by `@testable import Cinevo_iOS` and by the type names (`Cinevo_iOSApp`). File names drop the suffix (`CinevoApp.swift`, `CinevoTests.swift`) and so do not match their contained types.

There is no `Info.plist`; the app's plist is synthesized via `GENERATE_INFOPLIST_FILE = YES` plus `INFOPLIST_KEY_*` build settings, so plist changes are made in the build settings, not in a file.
