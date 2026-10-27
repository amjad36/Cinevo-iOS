//
//  SearchView.swift
//  Cinevo-iOS
//

import SwiftUI

struct SearchView: View {
    var body: some View {
        PlaceholderScreen(tab: .search, message: "Search for movies and TV shows.")
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            SearchView()
        }
    }
}
