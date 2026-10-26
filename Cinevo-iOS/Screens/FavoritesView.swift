//
//  FavoritesView.swift
//  Cinevo-iOS
//

import SwiftUI

struct FavoritesView: View {
    var body: some View {
        PlaceholderScreen(tab: .favorites, message: "Titles you favorite will appear here.")
    }
}

struct FavoritesView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            FavoritesView()
        }
    }
}
