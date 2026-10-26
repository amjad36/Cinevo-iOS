//
//  AppTab.swift
//  Cinevo-iOS
//

import Foundation

/// The top-level destinations shown in the custom bottom tab bar, in display order.
enum AppTab: String, CaseIterable, Identifiable {
    case home
    case trending
    case popular
    case search
    case favorites

    var id: String { rawValue }

    var title: String {
        switch self {
        case .home: return "Home"
        case .trending: return "Trending"
        case .popular: return "Popular"
        case .search: return "Search"
        case .favorites: return "Favorites"
        }
    }

    /// SF Symbol shown while the tab is not selected.
    var symbolName: String {
        switch self {
        case .home: return "house"
        case .trending: return "chart.bar"
        case .popular: return "trophy"
        case .search: return "magnifyingglass"
        case .favorites: return "heart"
        }
    }

    /// SF Symbol shown while the tab is selected. `magnifyingglass` has no filled variant.
    var selectedSymbolName: String {
        switch self {
        case .home: return "house.fill"
        case .trending: return "chart.bar.fill"
        case .popular: return "trophy.fill"
        case .search: return "magnifyingglass"
        case .favorites: return "heart.fill"
        }
    }
}
