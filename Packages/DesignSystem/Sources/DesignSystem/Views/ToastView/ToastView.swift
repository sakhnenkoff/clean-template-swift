import SwiftUI

public struct Toast: Equatable, Sendable {
    public let id: UUID
    public let style: ToastStyle
    public let message: String
    public let duration: Double

    public init(
        id: UUID = UUID(),
        style: ToastStyle,
        message: String,
        duration: Double = 3.0
    ) {
        self.id = id
        self.style = style
        self.message = message
        self.duration = duration
    }

    public static func error(_ message: String, duration: Double = 3.0) -> Toast {
        Toast(style: .error, message: message, duration: duration)
    }

    public static func success(_ message: String, duration: Double = 3.0) -> Toast {
        Toast(style: .success, message: message, duration: duration)
    }

    public static func warning(_ message: String, duration: Double = 3.0) -> Toast {
        Toast(style: .warning, message: message, duration: duration)
    }

    public static func info(_ message: String, duration: Double = 3.0) -> Toast {
        Toast(style: .info, message: message, duration: duration)
    }
}

public enum ToastStyle: Sendable {
    case error
    case warning
    case success
    case info

    /// Light pastel background for readability
    public var backgroundColor: Color {
        switch self {
        case .error: return .toastErrorBackground
        case .warning: return .toastWarningBackground
        case .success: return .toastSuccessBackground
        case .info: return .toastInfoBackground
        }
    }

    /// Colored accent for icon and left stripe
    public var accentColor: Color {
        switch self {
        case .error: return .toastErrorAccent
        case .warning: return .toastWarningAccent
        case .success: return .toastSuccessAccent
        case .info: return .toastInfoAccent
        }
    }

    /// Text color - dark in light mode, light in dark mode for contrast
    public var foregroundColor: Color {
        Color(light: .oxfordNavy, dark: .white)
    }

    public var icon: String {
        switch self {
        case .error: return "xmark.circle.fill"
        case .warning: return "exclamationmark.triangle.fill"
        case .success: return "checkmark.circle.fill"
        case .info: return "info.circle.fill"
        }
    }
}

public struct ToastView: View {
    let toast: Toast
    let onDismiss: () -> Void

    public init(toast: Toast, onDismiss: @escaping () -> Void) {
        self.toast = toast
        self.onDismiss = onDismiss
    }

    public var body: some View {
        HStack(alignment: .center, spacing: DSSpacing.smd) {
            Image(systemName: toast.style.icon)
                .foregroundColor(toast.style.accentColor)
                .font(.system(size: 20))

            Text(toast.message)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(toast.style.foregroundColor)
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)

            Button(action: onDismiss) {
                Image(systemName: "xmark")
                    .foregroundColor(toast.style.foregroundColor.opacity(0.6))
                    .font(.system(size: 12, weight: .semibold))
            }
        }
        .padding(.horizontal, DSSpacing.md)
        .padding(.vertical, DSSpacing.smd)
        .background(toast.style.backgroundColor)
        .clipShape(RoundedRectangle(cornerRadius: DSSpacing.smd))
        .shadow(color: .black.opacity(0.15), radius: DSSpacing.sm, x: 0, y: DSSpacing.xs)
        .padding(.horizontal, DSSpacing.md)
    }
}

#Preview("All Toasts - Light") {
    VStack(spacing: DSSpacing.md) {
        ToastView(toast: .success("Your changes have been saved.")) {}
        ToastView(toast: .error("Something went wrong. Please try again.")) {}
        ToastView(toast: .warning("Your session will expire soon.")) {}
        ToastView(toast: .info("New features are available!")) {}
    }
    .padding(.vertical, DSSpacing.mlg)
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(Color.backgroundPrimary)
    .preferredColorScheme(.light)
}

#Preview("All Toasts - Dark") {
    VStack(spacing: DSSpacing.md) {
        ToastView(toast: .success("Your changes have been saved.")) {}
        ToastView(toast: .error("Something went wrong. Please try again.")) {}
        ToastView(toast: .warning("Your session will expire soon.")) {}
        ToastView(toast: .info("New features are available!")) {}
    }
    .padding(.vertical, DSSpacing.mlg)
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(Color.backgroundPrimary)
    .preferredColorScheme(.dark)
}
