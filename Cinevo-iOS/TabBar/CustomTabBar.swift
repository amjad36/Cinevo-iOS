//
//  CustomTabBar.swift
//  Cinevo-iOS
//

import SwiftUI

/// A floating bottom tab bar. It only renders `AppTab`s and reports taps through `selection`;
/// which screen is shown for each tab is decided by the parent (see `MainTabView`).
struct CustomTabBar: View {
    @Binding var selection: AppTab
    var style: Style = .default

    var body: some View {
        HStack(spacing: style.itemSpacing) {
            ForEach(AppTab.allCases) { tab in
                item(for: tab)
            }
        }
        .padding(.horizontal, style.innerPadding)
        .padding(.vertical, style.innerPadding)
        .background(
            RoundedRectangle(cornerRadius: style.cornerRadius, style: .continuous)
                .fill(style.background)
                .shadow(color: style.shadowColor, radius: style.shadowRadius, y: style.shadowYOffset)
        )
        .overlay(
            RoundedRectangle(cornerRadius: style.cornerRadius, style: .continuous)
                .stroke(style.borderColor, lineWidth: 0.5)
        )
        .padding(.horizontal, style.outerPadding)
        .padding(.bottom, style.bottomPadding)
    }

    private func item(for tab: AppTab) -> some View {
        let isSelected = tab == selection

        return Button {
            guard tab != selection else { return }
            withAnimation(.easeInOut(duration: 0.2)) {
                selection = tab
            }
        } label: {
            VStack(spacing: 4) {
                Image(systemName: isSelected ? tab.selectedSymbolName : tab.symbolName)
                    .font(.system(size: style.iconSize, weight: isSelected ? .semibold : .regular))
                    .frame(height: style.iconSize + 4)
                    .scaleEffect(isSelected ? 1.08 : 1)

                Text(tab.title)
                    .font(.system(size: style.titleSize, weight: isSelected ? .semibold : .medium))
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
            }
            .foregroundColor(isSelected ? style.activeColor : style.inactiveColor)
            // Equal-width items keep spacing even; 48pt height exceeds the 44pt minimum touch target.
            .frame(maxWidth: .infinity, minHeight: 48)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityLabel(tab.title)
        .accessibilityAddTraits(isSelected ? .isSelected : [])
        .accessibilityIdentifier("tab.\(tab.rawValue)")
    }
}

extension CustomTabBar {
    /// Visual tuning knobs for the bar. Adjust `Style.default` to restyle it app-wide.
    struct Style {
        var activeColor: Color
        var inactiveColor: Color
        var background: Color
        var borderColor: Color
        var shadowColor: Color
        var shadowRadius: CGFloat
        var shadowYOffset: CGFloat
        var cornerRadius: CGFloat
        var iconSize: CGFloat
        var titleSize: CGFloat
        var itemSpacing: CGFloat
        var innerPadding: CGFloat
        var outerPadding: CGFloat
        var bottomPadding: CGFloat

        static let `default` = Style(
            activeColor: Color(red: 0x1E / 255, green: 0x6B / 255, blue: 0xFF / 255),
            inactiveColor: Color(.systemGray),
            background: Color(.secondarySystemGroupedBackground),
            borderColor: Color(.separator).opacity(0.4),
            shadowColor: Color.black.opacity(0.08),
            shadowRadius: 12,
            shadowYOffset: 4,
            cornerRadius: 26,
            iconSize: 20,
            titleSize: 11,
            itemSpacing: 0,
            innerPadding: 8,
            outerPadding: 16,
            bottomPadding: 4
        )
    }
}

struct CustomTabBar_Previews: PreviewProvider {
    private struct Container: View {
        @State private var selection: AppTab = .home

        var body: some View {
            VStack {
                Spacer()
                CustomTabBar(selection: $selection)
            }
            .background(Color(.systemGroupedBackground))
        }
    }

    static var previews: some View {
        Container()
        Container()
            .preferredColorScheme(.dark)
    }
}
