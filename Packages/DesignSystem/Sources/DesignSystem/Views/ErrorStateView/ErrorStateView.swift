import SwiftUI

/// A view for displaying error states with optional retry functionality.
/// Use this when an operation fails and the user needs to take action.
public struct ErrorStateView: View {
    let icon: String
    let title: String
    let message: String?
    let retryTitle: String?
    let onRetry: (() -> Void)?
    let dismissTitle: String?
    let onDismiss: (() -> Void)?

    public init(
        icon: String = "exclamationmark.triangle.fill",
        title: String = "Something Went Wrong",
        message: String? = nil,
        retryTitle: String? = "Try Again",
        onRetry: (() -> Void)? = nil,
        dismissTitle: String? = nil,
        onDismiss: (() -> Void)? = nil
    ) {
        self.icon = icon
        self.title = title
        self.message = message
        self.retryTitle = retryTitle
        self.onRetry = onRetry
        self.dismissTitle = dismissTitle
        self.onDismiss = onDismiss
    }

    /// Creates an ErrorStateView from an Error object.
    public init(
        error: Error,
        retryTitle: String? = "Try Again",
        onRetry: (() -> Void)? = nil,
        dismissTitle: String? = nil,
        onDismiss: (() -> Void)? = nil
    ) {
        self.icon = "exclamationmark.triangle.fill"
        self.title = "Something Went Wrong"
        self.message = error.localizedDescription
        self.retryTitle = retryTitle
        self.onRetry = onRetry
        self.dismissTitle = dismissTitle
        self.onDismiss = onDismiss
    }

    public var body: some View {
        VStack(spacing: DSSpacing.md) {
            Image(systemName: icon)
                .font(.system(size: 48, weight: .light))
                .foregroundStyle(Color.error)

            VStack(spacing: DSSpacing.sm) {
                Text(title)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(Color.textPrimary)
                    .multilineTextAlignment(.center)

                if let message {
                    Text(message)
                        .font(.system(size: 14, weight: .regular))
                        .foregroundStyle(Color.textSecondary)
                        .multilineTextAlignment(.center)
                }
            }

            VStack(spacing: DSSpacing.sm) {
                if let retryTitle, let onRetry {
                    Button(action: onRetry) {
                        Text(retryTitle)
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, DSSpacing.smd)
                            .background(Color.adaptiveError)
                            .clipShape(RoundedRectangle(cornerRadius: DSSpacing.sm))
                    }
                }

                if let dismissTitle, let onDismiss {
                    Button(action: onDismiss) {
                        Text(dismissTitle)
                            .font(.system(size: 14, weight: .medium))
                            .foregroundStyle(Color.textSecondary)
                    }
                }
            }
            .padding(.top, DSSpacing.sm)
        }
        .padding(DSSpacing.xl)
        .frame(maxWidth: .infinity)
    }
}

// MARK: - View Modifier

public extension View {
    /// Overlays an error state when an error is present.
    /// - Parameters:
    ///   - error: The error to display, or nil to show normal content
    ///   - retryTitle: The retry button title
    ///   - onRetry: The retry action
    /// - Returns: The view with an error state overlay when an error exists.
    @ViewBuilder
    func errorState(
        _ error: Error?,
        retryTitle: String = "Try Again",
        onRetry: @escaping () -> Void
    ) -> some View {
        if let error {
            ErrorStateView(
                error: error,
                retryTitle: retryTitle,
                onRetry: onRetry
            )
        } else {
            self
        }
    }

    /// Overlays an error state with full customization.
    @ViewBuilder
    func errorState(
        _ error: Error?,
        title: String = "Something Went Wrong",
        retryTitle: String = "Try Again",
        onRetry: @escaping () -> Void,
        dismissTitle: String? = nil,
        onDismiss: (() -> Void)? = nil
    ) -> some View {
        if error != nil {
            ErrorStateView(
                title: title,
                message: error?.localizedDescription,
                retryTitle: retryTitle,
                onRetry: onRetry,
                dismissTitle: dismissTitle,
                onDismiss: onDismiss
            )
        } else {
            self
        }
    }
}

// MARK: - Convenience Initializers

public extension ErrorStateView {
    /// Creates an error state for network/connection issues.
    static func networkError(
        onRetry: @escaping () -> Void
    ) -> ErrorStateView {
        ErrorStateView(
            icon: "wifi.exclamationmark",
            title: "Connection Problem",
            message: "Please check your internet connection and try again.",
            retryTitle: "Try Again",
            onRetry: onRetry
        )
    }

    /// Creates an error state for server errors.
    static func serverError(
        onRetry: @escaping () -> Void
    ) -> ErrorStateView {
        ErrorStateView(
            icon: "server.rack",
            title: "Server Error",
            message: "We're having trouble connecting to our servers. Please try again later.",
            retryTitle: "Try Again",
            onRetry: onRetry
        )
    }

    /// Creates an error state for permission issues.
    static func permissionDenied(
        feature: String,
        onOpenSettings: @escaping () -> Void
    ) -> ErrorStateView {
        ErrorStateView(
            icon: "lock.fill",
            title: "Permission Required",
            message: "Please grant \(feature) permission in Settings to use this feature.",
            retryTitle: "Open Settings",
            onRetry: onOpenSettings
        )
    }

    /// Creates an error state for content that failed to load.
    static func loadFailed(
        onRetry: @escaping () -> Void
    ) -> ErrorStateView {
        ErrorStateView(
            icon: "arrow.clockwise.circle",
            title: "Failed to Load",
            message: "We couldn't load this content. Please try again.",
            retryTitle: "Retry",
            onRetry: onRetry
        )
    }
}

// MARK: - Previews

#Preview("Default Error") {
    ErrorStateView(
        message: "An unexpected error occurred. Please try again.",
        onRetry: { print("Retry tapped") }
    )
    .background(Color.backgroundPrimary)
}

#Preview("With Dismiss") {
    ErrorStateView(
        title: "Upload Failed",
        message: "Your file could not be uploaded.",
        retryTitle: "Try Again",
        onRetry: { print("Retry tapped") },
        dismissTitle: "Cancel",
        onDismiss: { print("Dismiss tapped") }
    )
    .background(Color.backgroundPrimary)
}

#Preview("Network Error") {
    ErrorStateView.networkError(
        onRetry: { print("Retry network") }
    )
    .background(Color.backgroundPrimary)
}

#Preview("Server Error") {
    ErrorStateView.serverError(
        onRetry: { print("Retry server") }
    )
    .background(Color.backgroundPrimary)
}

#Preview("Permission Denied") {
    ErrorStateView.permissionDenied(
        feature: "camera",
        onOpenSettings: { print("Open settings") }
    )
    .background(Color.backgroundPrimary)
}

#Preview("View Modifier") {
    struct PreviewError: Error {
        var localizedDescription: String { "The operation failed." }
    }

    return Text("Content")
        .errorState(PreviewError(), onRetry: { print("Retry") })
}

#Preview("Dark Mode") {
    ErrorStateView(
        message: "Something went wrong",
        onRetry: { print("Retry") }
    )
    .background(Color.backgroundPrimary)
    .preferredColorScheme(.dark)
}
