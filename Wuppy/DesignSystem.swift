//
//  DesignSystem.swift
//  Wuppy
//
//  Created by Wuppy AI on 29/11/2025.
//

import SwiftUI

struct AppColors {
    static let background = Color(hex: "121212") // Deep dark background
    static let secondaryBackground = Color(hex: "1E1E1E") // Slightly lighter for sidebar
    static let cardBackground = Color(hex: "252525") // Card background
    static let accent = Color(hex: "00E5FF") // Vibrant Cyan/Teal
    static let textPrimary = Color.white
    static let textSecondary = Color.gray
    
    // Semantic colors
    static let income = Color(hex: "00E676") // Bright Green
    static let expense = Color(hex: "FF1744") // Bright Red
}

struct AppStyles {
    struct CardStyle: ViewModifier {
        func body(content: Content) -> some View {
            content
                .background(AppColors.cardBackground)
                .cornerRadius(16)
                .shadow(color: Color.black.opacity(0.2), radius: 8, x: 0, y: 4)
        }
    }
}

extension View {
    func wuppyCardStyle() -> some View {
        modifier(AppStyles.CardStyle())
    }
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
