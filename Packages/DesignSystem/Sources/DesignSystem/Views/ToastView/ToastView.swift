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

    public var color: Color {
        switch self {
        case .error: return DesignSystem.colors.error
        case .warning: return DesignSystem.colors.warning
        case .success: return DesignSystem.colors.success
        case .info: return DesignSystem.colors.info
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
        HStack(alignment: .center, spacing: 12) {
            Image(systemName: toast.style.icon)
                .foregroundColor(.white)
                .font(.system(size: 20))

            Text(toast.message)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.white)
                .multilineTextAlignment(.leading)

            Spacer(minLength: 10)

            Button(action: onDismiss) {
                Image(systemName: "xmark")
                    .foregroundColor(.white.opacity(0.8))
                    .font(.system(size: 14, weight: .bold))
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(toast.style.color)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.15), radius: 8, x: 0, y: 4)
        .padding(.horizontal, 16)
    }
}

#Preview("Error Toast") {
    VStack {
        Spacer()
        ToastView(toast: .error("Something went wrong. Please try again.")) {
            print("Dismissed")
        }
    }
}

#Preview("Success Toast") {
    VStack {
        Spacer()
        ToastView(toast: .success("Your changes have been saved.")) {
            print("Dismissed")
        }
    }
}

#Preview("Warning Toast") {
    VStack {
        Spacer()
        ToastView(toast: .warning("Your session will expire soon.")) {
            print("Dismissed")
        }
    }
}

#Preview("Info Toast") {
    VStack {
        Spacer()
        ToastView(toast: .info("New features are available!")) {
            print("Dismissed")
        }
    }
}
