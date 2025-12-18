import SwiftUI

/// Central design system singleton for theme management
public enum DesignSystem {

    // MARK: - Private Storage

    nonisolated(unsafe) private static var _theme: any Theme = DefaultTheme()
    private static let lock = NSLock()
    nonisolated(unsafe) private static var isConfigured = false

    // MARK: - Public API

    /// The current theme. Read-only after configuration.
    public static var theme: any Theme {
        _theme
    }

    /// Convenience accessor for colors
    public static var colors: ColorPalette {
        _theme.colors
    }

    /// Convenience accessor for typography
    public static var typography: TypographyScale {
        _theme.typography
    }

    /// Convenience accessor for spacing
    public static var spacing: SpacingScale {
        _theme.spacing
    }

    /// Configure the design system with a custom theme.
    /// Must be called once at app launch, before any UI is rendered.
    /// - Parameter theme: The theme to use throughout the app
    /// - Warning: This should only be called once. Subsequent calls will be ignored.
    public static func configure(theme: any Theme) {
        lock.lock()
        defer { lock.unlock() }

        guard !isConfigured else {
            #if DEBUG
            print("⚠️ DesignSystem.configure() called multiple times. Ignoring subsequent call.")
            #endif
            return
        }

        _theme = theme
        isConfigured = true
    }

    /// Configure with the default theme (useful for explicit initialization)
    public static func configureWithDefaults() {
        configure(theme: DefaultTheme())
    }

    /// Register custom fonts if needed
    public static func registerFonts() {
        // Add font registration logic here if using custom fonts
    }

    // MARK: - Testing Support

    #if DEBUG
    /// Reset the design system for testing purposes only
    internal static func reset() {
        lock.lock()
        defer { lock.unlock() }
        _theme = DefaultTheme()
        isConfigured = false
    }
    #endif
}
