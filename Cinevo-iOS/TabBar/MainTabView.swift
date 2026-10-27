//
//  MainTabView.swift
//  Cinevo-iOS
//

import SwiftUI

/// Owns the selected tab and hosts one screen per `AppTab` in the native tab bar.
struct MainTabView: View {
    /// Tint for the selected tab item. Unselected items use the system's standard appearance.
    private static let selectedTint = Color(red: 0x1E / 255, green: 0x6B / 255, blue: 0xFF / 255)

    @State private var selection: AppTab = .home

    var body: some View {
        TabView(selection: $selection) {
            ForEach(AppTab.allCases) { tab in
                // Each tab owns its own stack, so its navigation state survives switching tabs.
                NavigationStack {
                    screen(for: tab)
                }
                .tabItem {
                    Label(tab.title, systemImage: tab.symbolName)
                }
                .tag(tab)
            }
        }
        .tint(Self.selectedTint)
    }

    @ViewBuilder
    private func screen(for tab: AppTab) -> some View {
        switch tab {
        case .home: HomeView()
        case .trending: TrendingView()
        case .popular: PopularView()
        case .search: SearchView()
        case .favorites: FavoritesView()
        }
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
        MainTabView()
            .preferredColorScheme(.dark)
    }
}
