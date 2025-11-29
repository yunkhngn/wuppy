import SwiftUI

// MARK: - App Colors & Styles
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

// MARK: - Legacy Compatibility (To be refactored)
struct WuppyColor {
    static let cardBackground = AppColors.cardBackground
    static let primary = AppColors.accent
    static let secondary = AppColors.textSecondary
    
    // Gradients (Updated to match new theme)
    static let incomeGradient = LinearGradient(colors: [AppColors.income.opacity(0.8), AppColors.income.opacity(0.4)], startPoint: .topLeading, endPoint: .bottomTrailing)
    static let expenseGradient = LinearGradient(colors: [AppColors.expense.opacity(0.8), AppColors.expense.opacity(0.4)], startPoint: .topLeading, endPoint: .bottomTrailing)
    static let netResultGradient = LinearGradient(colors: [AppColors.accent.opacity(0.8), Color.purple.opacity(0.4)], startPoint: .topLeading, endPoint: .bottomTrailing)
}

// MARK: - Components

struct WuppyCard<Content: View>: View {
    let content: Content
    let padding: CGFloat
    let isInteractive: Bool
    
    @State private var isHovering = false
    
    init(padding: CGFloat = 16, isInteractive: Bool = false, @ViewBuilder content: () -> Content) {
        self.padding = padding
        self.isInteractive = isInteractive
        self.content = content()
    }
    
    var body: some View {
        content
            .padding(padding)
            .background(AppColors.cardBackground)
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.white.opacity(isHovering ? 0.1 : 0), lineWidth: 1)
            )
            .shadow(color: .black.opacity(isHovering ? 0.3 : 0.2), radius: isHovering ? 12 : 8, x: 0, y: 4)
            .animation(.easeInOut(duration: 0.2), value: isHovering)
            .onHover { hovering in
                if isInteractive {
                    isHovering = hovering
                }
            }
    }
}

struct WuppyTextField: View {
    let title: LocalizedStringKey
    @Binding var text: String
    var icon: String? = nil
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.caption)
                .fontWeight(.medium)
                .foregroundStyle(AppColors.textSecondary)
            
            HStack {
                if let icon = icon {
                    Image(systemName: icon)
                        .foregroundStyle(AppColors.textSecondary)
                        .frame(width: 20)
                }
                TextField("", text: $text)
                    .textFieldStyle(.plain)
                    .foregroundStyle(AppColors.textPrimary)
            }
            .padding(12)
            .background(AppColors.secondaryBackground)
            .cornerRadius(10)
        }
    }
}

struct WuppyNumberField<F: ParseableFormatStyle>: View where F.FormatInput == Double, F.FormatOutput == String {
    let title: LocalizedStringKey
    @Binding var value: Double
    var format: F
    var icon: String? = nil
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.caption)
                .fontWeight(.medium)
                .foregroundStyle(AppColors.textSecondary)
            
            HStack {
                if let icon = icon {
                    Image(systemName: icon)
                        .foregroundStyle(AppColors.textSecondary)
                        .frame(width: 20)
                }
                TextField("", value: $value, format: format)
                    .textFieldStyle(.plain)
                    .foregroundStyle(AppColors.textPrimary)
            }
            .padding(12)
            .background(AppColors.secondaryBackground)
            .cornerRadius(10)
        }
    }
}

struct WuppySectionHeader: View {
    let title: LocalizedStringKey
    let icon: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundStyle(AppColors.accent)
            Text(title)
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundStyle(AppColors.textPrimary)
        }
        .padding(.bottom, 8)
        .padding(.top, 16)
    }
}

