//
//  HomeView.swift
//  Cinevo-iOS
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        PlaceholderScreen(tab: .home, message: "Your movie and TV highlights will appear here.")
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            HomeView()
        }
    }
}
