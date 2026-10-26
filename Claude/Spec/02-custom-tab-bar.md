# Prompt for Claude: Build a Custom Bottom Tab Bar in SwiftUI

I want to implement a custom bottom tab bar in my existing iOS application using **SwiftUI**, based on the attached screenshot.

## 1. UI Design Requirements

Create a custom bottom navigation bar with five tabs arranged horizontally:

1. **Home** — house icon
2. **Trending** — chart/bar graph icon
3. **Popular** — trophy icon
4. **Search** — magnifying glass icon
5. **Favorites** — heart icon

### Visual design
- Use SF Symbols for all icons.
- Use a clean, modern, minimal design matching the attached screenshot.
- The tab bar should have a white or subtle off-white background.
- The selected tab should use a bright blue color for both its icon and title.
- Unselected tabs should use a light gray or muted blue-gray color.
- Place the icon above the tab title.
- Keep equal spacing between all five tabs.
- Add rounded bottom navigation container corners, approximately 24–28 points.
- Add a subtle shadow or border to separate the bar from the content.
- Make the tab bar responsive to different iPhone screen sizes.
- Respect safe areas and support light and dark mode appropriately.

## 2. Functional Requirements

- Home must be selected by default.
- Tapping a tab must update the selected state immediately.
- Only the selected tab should display the active blue styling.
- Each tab must navigate to its corresponding screen.
- Preserve the selected tab state while switching between tabs when appropriate.
- Use smooth, subtle animations when changing tabs.
- Ensure accessibility labels and adequate touch targets.

## 3. Architecture and Code Quality

My project uses **SwiftUI and MVVM with Clean Architecture**.

Please follow these guidelines:
- Keep the custom tab bar UI reusable and independent of individual screen implementations.
- Create a dedicated `CustomTabBar` SwiftUI view.
- Use a strongly typed enum such as `AppTab` to represent the available tabs.
- Use `@State` or `@Binding` appropriately to manage the selected tab.
- Keep navigation and screen composition separate from the tab bar's visual implementation.
- Avoid putting networking, business logic, or API calls inside the tab bar.
- Do not introduce unnecessary protocols, repositories, use cases, or ViewModels for simple UI state.
- Use native SwiftUI components and SF Symbols instead of third-party libraries.

## 4. Suggested SF Symbols

Use these symbols or suitable alternatives:
- Home: `house.fill`
- Trending: `chart.bar`
- Popular: `trophy`
- Search: `magnifyingglass`
- Favorites: `heart`

For the selected tab, use filled variants where available and visually appropriate.

## 5. Expected Implementation

Please provide complete, compilable Swift code for:

1. `AppTab.swift` — enum for the five tabs, including titles and SF Symbol names.
2. `CustomTabBar.swift` — reusable custom bottom tab bar.
3. `MainTabView.swift` — parent view that manages tab selection and displays the appropriate screen.
4. Five placeholder screen views for Home, Trending, Popular, Search, and Favorites, if these screens do not already exist.

## 6. Important Instructions

Before writing code:
- Inspect my existing project structure and identify the current app entry point, root view, and navigation setup.
- Reuse my existing screen views and project conventions wherever possible.
- Do not create duplicate screens or replace existing business logic.
- Integrate the custom tab bar into the existing application rather than building an unrelated demo app.
- If my project already uses a navigation architecture, preserve it and explain how the custom tab bar fits into it.
- Make sure the solution compiles and works with my project's current iOS deployment target.

After implementation, explain:
- Which files were created or modified.
- Where the selected tab state is managed.
- How navigation works.
- How I can change the active and inactive colors, icon sizes, spacing, corner radius, and shadow.
- How to connect the tabs to my existing screens.

First inspect the project, then implement the solution. Do not assume file names or project structure without checking.
