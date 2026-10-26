//
//  PopularView.swift
//  Cinevo-iOS
//

import SwiftUI

struct PopularView: View {
    var body: some View {
        PlaceholderScreen(tab: .popular, message: "Popular titles will appear here.")
    }
}

struct PopularView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            PopularView()
        }
    }
}
