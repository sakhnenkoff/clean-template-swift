import SwiftUI

/// A standardized button component following the design system.
/// Supports multiple styles, sizes, and loading states.
public struct DSButton: View {
    let title: String
    let icon: String?
    let style: DSButtonStyle
    let size: DSButtonSize
    let isLoading: Bool
    let isEnabled: Bool
    let isFullWidth: Bool
    let action: () -> Void

    public init(
        title: String,
        icon: String? = nil,
        style: DSButtonStyle = .primary,
        size: DSButtonSize = .medium,
        isLoading: Bool = false,
        isEnabled: Bool = true,
        isFullWidth: Bool = false,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.icon = icon
        self.style = style
        self.size = size
        self.isLoading = isLoading
        self.isEnabled = isEnabled
        self.isFullWidth = isFullWidth
        self.action = action
    }

    public var body: some View {
        Button(action: {
            if !isLoading && isEnabled {
                action()
            }
        }) {
            HStack(spacing: DSSpacing.sm) {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .tint(style.foregroundColor)
                        .scaleEffect(0.8)
                } else {
                    if let icon {
                        Image(systemName: icon)
                            .font(.system(size: size.iconSize, weight: .semibold))
                    }

                    Text(title)
                        .font(.system(size: size.fontSize, weight: .semibold))
                }
            }
            .foregroundStyle(style.foregroundColor)
            .padding(.horizontal, size.horizontalPadding)
            .padding(.vertical, size.verticalPadding)
            .frame(maxWidth: isFullWidth ? .infinity : nil)
            .background(style.backgroundColor)
            .clipShape(RoundedRectangle(cornerRadius: size.cornerRadius))
            .overlay(
                RoundedRectangle(cornerRadius: size.cornerRadius)
                    .strokeBorder(style.borderColor, lineWidth: style.borderWidth)
            )
        }
        .disabled(!isEnabled || isLoading)
        .opacity(isEnabled ? 1.0 : 0.5)
    }
}

// MARK: - Button Style

public enum DSButtonStyle {
    /// Filled button with primary theme color
    case primary

    /// Outlined button with primary theme color border
    case secondary

    /// Text-only button without background
    case tertiary

    /// Filled button with error color for destructive actions
    case destructive

    var backgroundColor: Color {
        switch self {
        case .primary:
            return .themePrimary
        case .secondary:
            return .clear
        case .tertiary:
            return .clear
        case .destructive:
            return .adaptiveError
        }
    }

    var foregroundColor: Color {
        switch self {
        case .primary:
            return .white
        case .secondary:
            return .themePrimary
        case .tertiary:
            return .themePrimary
        case .destructive:
            return .white
        }
    }

    var borderColor: Color {
        switch self {
        case .primary:
            return .clear
        case .secondary:
            return .themePrimary
        case .tertiary:
            return .clear
        case .destructive:
            return .clear
        }
    }

    var borderWidth: CGFloat {
        switch self {
        case .secondary:
            return 1.5
        default:
            return 0
        }
    }
}

// MARK: - Button Size

public enum DSButtonSize {
    case small
    case medium
    case large

    var fontSize: CGFloat {
        switch self {
        case .small: return 13
        case .medium: return 15
        case .large: return 17
        }
    }

    var iconSize: CGFloat {
        switch self {
        case .small: return 12
        case .medium: return 14
        case .large: return 16
        }
    }

    var horizontalPadding: CGFloat {
        switch self {
        case .small: return DSSpacing.smd
        case .medium: return DSSpacing.md
        case .large: return DSSpacing.lg
        }
    }

    var verticalPadding: CGFloat {
        switch self {
        case .small: return DSSpacing.sm
        case .medium: return DSSpacing.smd
        case .large: return DSSpacing.md
        }
    }

    var cornerRadius: CGFloat {
        switch self {
        case .small: return DSSpacing.sm
        case .medium: return DSSpacing.smd
        case .large: return DSSpacing.md
        }
    }
}

// MARK: - Convenience Initializers

public extension DSButton {
    /// Creates a primary full-width CTA button.
    static func cta(
        title: String,
        icon: String? = nil,
        isLoading: Bool = false,
        isEnabled: Bool = true,
        action: @escaping () -> Void
    ) -> DSButton {
        DSButton(
            title: title,
            icon: icon,
            style: .primary,
            size: .large,
            isLoading: isLoading,
            isEnabled: isEnabled,
            isFullWidth: true,
            action: action
        )
    }

    /// Creates a destructive action button.
    static func destructive(
        title: String,
        icon: String? = "trash",
        isLoading: Bool = false,
        action: @escaping () -> Void
    ) -> DSButton {
        DSButton(
            title: title,
            icon: icon,
            style: .destructive,
            size: .medium,
            isLoading: isLoading,
            action: action
        )
    }

    /// Creates a text-only link-style button.
    static func link(
        title: String,
        action: @escaping () -> Void
    ) -> DSButton {
        DSButton(
            title: title,
            style: .tertiary,
            size: .medium,
            action: action
        )
    }
}

// MARK: - Icon-Only Button

/// A button that displays only an icon without text.
public struct DSIconButton: View {
    let icon: String
    let style: DSButtonStyle
    let size: DSIconButtonSize
    let action: () -> Void

    public init(
        icon: String,
        style: DSButtonStyle = .tertiary,
        size: DSIconButtonSize = .medium,
        action: @escaping () -> Void
    ) {
        self.icon = icon
        self.style = style
        self.size = size
        self.action = action
    }

    public var body: some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.system(size: size.iconSize, weight: .semibold))
                .foregroundStyle(style.foregroundColor)
                .frame(width: size.dimension, height: size.dimension)
                .background(style.backgroundColor)
                .clipShape(Circle())
                .overlay(
                    Circle()
                        .strokeBorder(style.borderColor, lineWidth: style.borderWidth)
                )
        }
    }
}

public enum DSIconButtonSize {
    case small
    case medium
    case large

    var iconSize: CGFloat {
        switch self {
        case .small: return 14
        case .medium: return 18
        case .large: return 22
        }
    }

    var dimension: CGFloat {
        switch self {
        case .small: return 32
        case .medium: return 44
        case .large: return 56
        }
    }
}

// MARK: - Previews

#Preview("Primary Buttons") {
    VStack(spacing: DSSpacing.md) {
        DSButton(title: "Small Primary", size: .small) {}
        DSButton(title: "Medium Primary", size: .medium) {}
        DSButton(title: "Large Primary", size: .large) {}
        DSButton(title: "With Icon", icon: "arrow.right", size: .medium) {}
        DSButton(title: "Full Width", isFullWidth: true) {}
    }
    .padding()
    .background(Color.backgroundPrimary)
}

#Preview("Secondary Buttons") {
    VStack(spacing: DSSpacing.md) {
        DSButton(title: "Small Secondary", style: .secondary, size: .small) {}
        DSButton(title: "Medium Secondary", style: .secondary) {}
        DSButton(title: "Large Secondary", style: .secondary, size: .large) {}
        DSButton(title: "With Icon", icon: "plus", style: .secondary) {}
    }
    .padding()
    .background(Color.backgroundPrimary)
}

#Preview("Tertiary & Destructive") {
    VStack(spacing: DSSpacing.md) {
        DSButton(title: "Tertiary Button", style: .tertiary) {}
        DSButton(title: "Destructive Button", style: .destructive) {}
        DSButton.destructive(title: "Delete", action: {})
        DSButton.link(title: "Learn More", action: {})
    }
    .padding()
    .background(Color.backgroundPrimary)
}

#Preview("States") {
    VStack(spacing: DSSpacing.md) {
        DSButton(title: "Normal") {}
        DSButton(title: "Loading", isLoading: true) {}
        DSButton(title: "Disabled", isEnabled: false) {}
    }
    .padding()
    .background(Color.backgroundPrimary)
}

#Preview("CTA Button") {
    VStack(spacing: DSSpacing.md) {
        DSButton.cta(title: "Continue") {}
        DSButton.cta(title: "Loading...", isLoading: true) {}
        DSButton.cta(title: "Disabled", isEnabled: false) {}
    }
    .padding()
    .background(Color.backgroundPrimary)
}

#Preview("Icon Buttons") {
    HStack(spacing: DSSpacing.md) {
        DSIconButton(icon: "heart.fill", style: .primary, size: .small) {}
        DSIconButton(icon: "heart.fill", style: .primary, size: .medium) {}
        DSIconButton(icon: "heart.fill", style: .primary, size: .large) {}
        DSIconButton(icon: "plus", style: .secondary) {}
        DSIconButton(icon: "xmark", style: .tertiary) {}
    }
    .padding()
    .background(Color.backgroundPrimary)
}

#Preview("Dark Mode") {
    VStack(spacing: DSSpacing.md) {
        DSButton(title: "Primary") {}
        DSButton(title: "Secondary", style: .secondary) {}
        DSButton(title: "Destructive", style: .destructive) {}
        DSButton.cta(title: "Get Started") {}
    }
    .padding()
    .background(Color.backgroundPrimary)
    .preferredColorScheme(.dark)
}
