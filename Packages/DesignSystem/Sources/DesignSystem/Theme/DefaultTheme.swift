import SwiftUI

/// The default theme matching current hardcoded values
public struct DefaultTheme: Theme, Sendable {
    public let colors: ColorPalette
    public let typography: TypographyScale
    public let spacing: SpacingScale

    public init() {
        self.colors = ColorPalette(
            // Brand
            primary: .blue,
            secondary: .gray,
            accent: .accentColor,
            // Semantic
            success: .green,
            warning: .orange,
            error: .red,
            info: .blue,
            // Backgrounds
            backgroundPrimary: Color(uiColor: .systemBackground),
            backgroundSecondary: Color(uiColor: .secondarySystemBackground),
            backgroundTertiary: Color(uiColor: .tertiarySystemBackground),
            // Text
            textPrimary: Color(uiColor: .label),
            textSecondary: Color(uiColor: .secondaryLabel),
            textTertiary: Color(uiColor: .tertiaryLabel),
            textOnPrimary: .white,
            // Surface
            surface: Color(uiColor: .systemBackground),
            surfaceVariant: Color(uiColor: .secondarySystemBackground),
            border: Color(uiColor: .separator),
            divider: Color(uiColor: .opaqueSeparator)
        )

        self.typography = TypographyScale(
            // Titles
            titleLarge: TextStyle(size: 34, weight: .bold),
            titleMedium: TextStyle(size: 28, weight: .bold),
            titleSmall: TextStyle(size: 22, weight: .bold),
            // Headlines
            headlineLarge: TextStyle(size: 20, weight: .semibold),
            headlineMedium: TextStyle(size: 17, weight: .semibold),
            headlineSmall: TextStyle(size: 15, weight: .semibold),
            // Body
            bodyLarge: TextStyle(size: 17, weight: .regular),
            bodyMedium: TextStyle(size: 15, weight: .regular),
            bodySmall: TextStyle(size: 13, weight: .regular),
            // Caption
            captionLarge: TextStyle(size: 12, weight: .regular),
            captionSmall: TextStyle(size: 11, weight: .regular),
            // Button
            buttonLarge: TextStyle(size: 17, weight: .semibold),
            buttonMedium: TextStyle(size: 15, weight: .semibold),
            buttonSmall: TextStyle(size: 13, weight: .semibold)
        )

        self.spacing = SpacingScale(
            xs: 4,
            sm: 8,
            md: 16,
            lg: 24,
            xl: 32,
            xxl: 48
        )
    }
}
