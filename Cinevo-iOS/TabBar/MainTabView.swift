//
//  MainTabView.swift
//  Cinevo-iOS
//

import SwiftUI

/// Owns the selected tab and composes one screen per `AppTab` above the `CustomTabBar`.
struct MainTabView: View {
    @State private var selection: AppTab = .home

    var body: some View {
        ZStack {
            // Every tab stays in the hierarchy so its navigation stack and scroll position
            // survive switching away; only the selected one is visible and interactive.
            ForEach(AppTab.allCases) { tab in
                NavigationStack {
                    screen(for: tab)
                }
                .opacity(tab == selection ? 1 : 0)
                .allowsHitTesting(tab == selection)
                .accessibilityHidden(tab != selection)
            }
        }
        .safeAreaInset(edge: .bottom, spacing: 0) {
            CustomTabBar(selection: $selection)
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
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
