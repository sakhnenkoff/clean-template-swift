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

    /// Solid background color from palette
    public var backgroundColor: Color {
        switch self {
        case .error: return .adaptiveError
        case .warning: return .adaptiveWarning
        case .success: return .adaptiveSuccess
        case .info: return .adaptivePrimary
        }
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
                .foregroundStyle(.white)
                .font(.system(size: 20, weight: .semibold))

            Text(toast.message)
                .font(.system(size: 14, weight: .medium))
                .foregroundStyle(.white)
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)

            Button(action: onDismiss) {
                Image(systemName: "xmark")
                    .foregroundStyle(.white.opacity(0.8))
                    .font(.system(size: 12, weight: .bold))
            }
        }
        .padding(.horizontal, DSSpacing.md)
        .padding(.vertical, DSSpacing.smd)
        .background(toast.style.backgroundColor)
        .clipShape(RoundedRectangle(cornerRadius: DSSpacing.smd))
        .shadow(color: .black.opacity(0.1), radius: 1, x: 0, y: 1)
        .shadow(color: .black.opacity(0.15), radius: 8, x: 0, y: 4)
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
