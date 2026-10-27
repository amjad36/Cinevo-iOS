//
//  PlaceholderScreen.swift
//  Cinevo-iOS
//

import SwiftUI

/// Temporary body for tab screens that have no real content yet.
struct PlaceholderScreen: View {
    let tab: AppTab
    let message: String

    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: tab.symbolName)
                .font(.system(size: 44, weight: .regular))
                .foregroundColor(.secondary)
            Text(message)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemGroupedBackground))
        .navigationTitle(tab.title)
    }
}
