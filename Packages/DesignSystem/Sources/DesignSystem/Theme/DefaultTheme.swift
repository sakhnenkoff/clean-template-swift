import SwiftUI

/// The default theme matching current hardcoded values
public struct DefaultTheme: Theme, Sendable {
    public let colors: ColorPalette
    public let typography: TypographyScale
    public let spacing: SpacingScale

    public init() {
        self.colors = ColorPalette(
            // Brand Colors (adaptive for dark mode)
            primary: .adaptivePrimary,          // Yale Blue (light) / Sky Blue (dark)
            secondary: .adaptiveSecondary,      // Oxford Navy (light) / Periwinkle (dark)
            accent: .adaptiveAccent,            // Prussian Blue (light) / Steel Blue (dark)
            // Semantic Colors (adaptive for dark mode)
            success: .adaptiveSuccess,          // Sage Green (light) / Light Sage (dark)
            warning: .adaptiveWarning,          // Goldenrod (light) / Light Gold (dark)
            error: .adaptiveError,              // Coral Red (light) / Light Coral (dark)
            info: .adaptiveInfo,                // Powder Blue (light) / Light Powder Blue (dark)
            // Background Colors
            backgroundPrimary: Color(uiColor: .systemBackground),                  // Keep system adaptive
            backgroundSecondary: Color(uiColor: .secondarySystemBackground),       // Keep system adaptive
            backgroundTertiary: .adaptiveTertiaryBackground,                       // Mint Cream (light) / Pale Mint (dark)
            // Text Colors
            textPrimary: Color(uiColor: .label),                                   // Keep system adaptive
            textSecondary: Color(uiColor: .secondaryLabel),                        // Keep system adaptive
            textTertiary: Color(uiColor: .tertiaryLabel),                          // Keep system adaptive
            textOnPrimary: .white,                                                 // White for contrast on dark blues
            // Surface Colors
            surface: Color(uiColor: .systemBackground),                            // Keep system adaptive
            surfaceVariant: Color(uiColor: .secondarySystemBackground),            // Keep system adaptive
            border: Color(uiColor: .separator),                                    // Keep system adaptive
            divider: Color(uiColor: .opaqueSeparator)                              // Keep system adaptive
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
            smd: 12,
            md: 16,
            mlg: 20,
            lg: 24,
            xl: 32,
            xxlg: 40,
            xxl: 48
        )
    }
}
