# Prompt for Claude: Implement a Native SwiftUI Tab Bar in iOS

I want to implement a **native bottom tab bar using SwiftUI `TabView`** in my existing iOS application. Do not create a custom tab bar. Use Apple's native tab bar implementation and follow my existing project architecture and conventions.

## 1. Tab Bar Requirements

Create a native bottom tab bar with five tabs arranged horizontally:

1. **Home** — house icon
2. **Trending** — chart/bar graph icon
3. **Popular** — trophy icon
4. **Search** — magnifying glass icon
5. **Favorites** — heart icon

### UI Requirements

- Use SwiftUI's native `TabView` and `tabItem` APIs, or the appropriate modern SwiftUI tab APIs supported by my project's deployment target.
- Use SF Symbols for all tab icons.
- Use the system-provided tab bar appearance, layout, safe-area handling, and platform behavior.
- Use these SF Symbols or suitable alternatives:
  - Home: `house.fill`
  - Trending: `chart.bar`
  - Popular: `trophy`
  - Search: `magnifyingglass`
  - Favorites: `heart`
- Use a bright blue tint for the selected tab.
- Allow the system to render inactive tabs using the appropriate standard appearance.
- Support light mode and dark mode using native system behavior.
- Ensure the tab bar adapts to different iPhone screen sizes and safe areas.
- Do not manually implement tab icons, titles, tab backgrounds, shadows, rounded containers, or selection indicators.
- Do not use a custom `HStack`, `Button` collection, `overlay`, or custom bottom bar view to replicate the native tab bar.

The primary goal is to use the native iOS tab bar, not to reproduce the appearance of a custom-designed navigation bar.

## 2. Functional Requirements

- Home must be selected by default.
- Tapping a tab must display its corresponding screen.
- The selected tab must update automatically through SwiftUI's tab selection mechanism.
- Use a strongly typed enum such as `AppTab` to represent the available tabs, where appropriate.
- Preserve each tab's navigation state when switching tabs if the existing navigation architecture and implementation support it.
- Use native SwiftUI navigation APIs, such as `NavigationStack`, where appropriate.
- Support independent navigation stacks per tab if required by the existing application architecture.
- Avoid unnecessary animations or custom selection transitions that interfere with native tab bar behavior.
- Provide appropriate accessibility labels and native touch targets.

## 3. Architecture and Code Quality

My project uses **SwiftUI, MVVM, and Clean Architecture**.

Follow these guidelines:

- Keep the tab navigation and screen composition separate from individual screen implementations.
- Use `TabView(selection:)` with a strongly typed selection value when appropriate.
- Use `@State` for local tab selection or integrate with an existing shared state-management approach if the project already has one.
- Keep networking, API calls, and business logic out of the tab navigation container.
- Reuse existing ViewModels, use cases, repositories, domain models, and screen views wherever appropriate.
- Do not introduce unnecessary protocols, repositories, use cases, or ViewModels just to manage simple tab selection.
- Follow the project's existing dependency injection, routing, and navigation conventions.
- Use native SwiftUI APIs and avoid third-party libraries unless the project already depends on one and it is genuinely needed.
- Do not introduce a `CustomTabBar` component or any other custom-drawn replacement for the native tab bar.

## 4. Expected Implementation

Implement the following components where needed, adapting the filenames to the existing project structure:

### `AppTab.swift`

- Define a strongly typed enum for Home, Trending, Popular, Search, and Favorites.
- Conform to `Hashable` and any other protocols required by the implementation.
- Define tab titles and SF Symbol names in one place where practical.
- Avoid duplicating tab configuration across multiple files.

### `MainTabView.swift`

- Use native SwiftUI `TabView` as the main tab container.
- Configure all five tabs with their respective titles, SF Symbols, and unique selection values.
- Set Home as the default selected tab.
- Apply the selected tint color using an appropriate SwiftUI API compatible with the deployment target.
- Integrate existing screen views rather than recreating them.
- Use `NavigationStack` inside individual tabs when appropriate.
- Preserve independent navigation state across tabs where required.
- Keep the implementation simple, readable, and consistent with the project's architecture.

### Existing Screen Views

Integrate these screens:

- Home
- Trending
- Popular
- Search
- Favorites

If any screen does not exist, create a minimal placeholder only for that missing screen. Do not duplicate or overwrite existing screens.

## 5. Important Navigation and Compatibility Rules

- Inspect the project's current iOS deployment target before selecting SwiftUI APIs.
- Prefer native SwiftUI APIs that work with the project's current deployment target.
- If using newer APIs such as the modern `Tab` and `TabView` composition APIs, verify that they are available for the deployment target. Otherwise, use the compatible `TabView(selection:)` and `.tabItem` approach.
- Do not use UIKit-based custom tab bar controllers unless the existing project architecture specifically requires them.
- Do not customize the native tab bar's appearance unless explicitly necessary for an existing application requirement.
- Avoid deprecated APIs when a compatible alternative is available.
- Ensure each tab has a stable, unique selection value.
- Prevent duplicate `NavigationStack` instances or conflicting navigation ownership.
- Keep the native tab bar visible or hidden according to the existing screen flow, using supported SwiftUI navigation behavior.

## 6. Mandatory Project Inspection Before Implementation

Before writing or modifying any code:

1. Inspect the project directory and identify the application entry point.
2. Locate the existing root view and navigation setup.
3. Identify the current iOS deployment target and Swift version.
4. Review the existing Home, Trending, Popular, Search, and Favorites screen implementations.
5. Understand how the existing project organizes Presentation, Domain, and Data layers.
6. Identify any existing routing, dependency injection, and shared state-management conventions.
7. Determine the smallest set of changes needed to integrate the native tab bar.

After inspection, implement the solution directly in the existing project.

**Do not build an unrelated demo application. Do not assume filenames or project structure. Do not overwrite existing business logic or introduce duplicate screens.**

## 7. Validation

After implementation:

- Build the project using the available project tooling.
- Resolve compilation errors caused by your changes.
- Verify that all five tabs are configured with unique selection values.
- Verify that Home is selected by default.
- Verify that tapping each tab displays the correct screen.
- Check navigation behavior and state preservation when switching tabs.
- Check compatibility with the project's deployment target.
- Report any validation steps that could not be performed.

Do not claim that the project builds successfully unless you have actually verified the build.

## 8. Final Summary

After completing the implementation, explain:

1. Which files were created or modified.
2. How the native `TabView` is integrated into the existing application.
3. Where the selected tab state is managed.
4. How navigation works within each tab.
5. How to change the selected tab's tint color.
6. How to connect additional screens or add another
