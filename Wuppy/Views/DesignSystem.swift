import SwiftUI

// MARK: - Colors & Gradients
struct WuppyColor {
    static let cardBackground = Color("CardBackground") // We will need to define this in Assets or use system materials
    static let primary = Color.accentColor
    static let secondary = Color.secondary
    
    // Gradients
    static let incomeGradient = LinearGradient(colors: [.green.opacity(0.8), .green.opacity(0.4)], startPoint: .topLeading, endPoint: .bottomTrailing)
    static let expenseGradient = LinearGradient(colors: [.red.opacity(0.8), .red.opacity(0.4)], startPoint: .topLeading, endPoint: .bottomTrailing)
    static let netResultGradient = LinearGradient(colors: [.blue.opacity(0.8), .purple.opacity(0.4)], startPoint: .topLeading, endPoint: .bottomTrailing)
    static let cardGradient = LinearGradient(colors: [Color(nsColor: .controlBackgroundColor).opacity(0.8), Color(nsColor: .controlBackgroundColor).opacity(0.5)], startPoint: .topLeading, endPoint: .bottomTrailing)
}

// MARK: - Components

struct WuppyCard<Content: View>: View {
    let content: Content
    let padding: CGFloat
    
    init(padding: CGFloat = 16, @ViewBuilder content: () -> Content) {
        self.padding = padding
        self.content = content()
    }
    
    var body: some View {
        content
            .padding(padding)
            .background(.ultraThinMaterial)
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(.white.opacity(0.2), lineWidth: 1)
            )
            .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
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
                .foregroundStyle(.secondary)
            
            HStack {
                if let icon = icon {
                    Image(systemName: icon)
                        .foregroundStyle(.secondary)
                        .frame(width: 20)
                }
                TextField("", text: $text)
                    .textFieldStyle(.plain)
            }
            .padding(12)
            .background(Color(nsColor: .controlBackgroundColor))
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.secondary.opacity(0.2), lineWidth: 1)
            )
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
                .foregroundStyle(.secondary)
            
            HStack {
                if let icon = icon {
                    Image(systemName: icon)
                        .foregroundStyle(.secondary)
                        .frame(width: 20)
                }
                TextField("", value: $value, format: format)
                    .textFieldStyle(.plain)
            }
            .padding(12)
            .background(Color(nsColor: .controlBackgroundColor))
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.secondary.opacity(0.2), lineWidth: 1)
            )
        }
    }
}

struct WuppySectionHeader: View {
    let title: LocalizedStringKey
    let icon: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundStyle(.blue)
            Text(title)
                .font(.headline)
                .fontWeight(.semibold)
        }
        .padding(.bottom, 8)
        .padding(.top, 16)
    }
}
struct HoverEffectModifier: ViewModifier {
    @State private var isHovering = false
    
    func body(content: Content) -> some View {
        content
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isHovering ? Color.secondary.opacity(0.1) : Color.clear)
            )
            .onHover { hovering in
                withAnimation(.easeInOut(duration: 0.2)) {
                    isHovering = hovering
                }
            }
    }
}

extension View {
    func wuppyHoverEffect() -> some View {
        modifier(HoverEffectModifier())
    }
}
