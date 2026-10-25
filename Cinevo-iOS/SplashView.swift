//
//  SplashView.swift
//  Cinevo-iOS
//
//  Created by Amjad on 24/10/26.
//

import SwiftUI

struct SplashView: View {
    var body: some View {
        ZStack {
            Color("LaunchBackground")
                .ignoresSafeArea()

            // The poster wall art is already tilted and faded; fill the screen and crop the overflow.
            Image("Splash_Image")
                .resizable()
                .scaledToFill()
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                .clipped()
                .ignoresSafeArea()

            VStack(spacing: 16) {
                Image("SplashLogo")
                    .resizable()
                    .scaledToFit()
                    .scaleEffect(1.17)
                    .frame(width: 88, height: 88)
                    .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                    .shadow(color: Color.splashTitle.opacity(0.15), radius: 12, y: 6)

                Text("Cinevo")
                    .font(.system(size: 44, weight: .bold, design: .rounded))
                    .foregroundColor(.splashTitle)

                Text("Discover great movies\nand TV shows")
                    .font(.system(size: 17, weight: .medium))
                    .foregroundColor(.splashTagline)
                    .multilineTextAlignment(.center)
            }

            VStack {
                Spacer()
                Text("This product uses the TMDB API\nbut is not endorsed or certified by TMDB.")
                    .font(.system(size: 11))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 24)
            }
        }
        .preferredColorScheme(.light)
    }
}

private extension Color {
    static let splashTitle = Color(red: 0x0D / 255, green: 0x2A / 255, blue: 0x5C / 255)
    static let splashTagline = Color(red: 0x1E / 255, green: 0x3A / 255, blue: 0x6E / 255)
}

struct SplashView_Previews: PreviewProvider {
    static var previews: some View {
        SplashView()
    }
}
