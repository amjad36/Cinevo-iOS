//
//  TrendingView.swift
//  Cinevo-iOS
//

import SwiftUI

struct TrendingView: View {
    var body: some View {
        PlaceholderScreen(tab: .trending, message: "Trending titles will appear here.")
    }
}

struct TrendingView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            TrendingView()
        }
    }
}
