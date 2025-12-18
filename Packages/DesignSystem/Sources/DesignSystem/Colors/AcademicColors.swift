import SwiftUI

/// Academic color palette with sophisticated blues and complementary colors
public extension Color {

    // MARK: - Light Mode Brand Colors

    /// Yale Blue - Deep and striking, radiates academic prestige
    static let yaleBlue = Color(hex: "134074")

    /// Oxford Navy - Deep, dignified blue reminiscent of midnight sky
    static let oxfordNavy = Color(hex: "13315C")

    /// Prussian Blue - Inky, profound blue filled with gravitas
    static let prussianBlue = Color(hex: "0B2545")

    /// Powder Blue - Soft, comforting blue gently wraps settings
    static let powderBlue = Color(hex: "8DA9C4")

    /// Mint Cream - Cool and pristine shade like first light on snow
    static let mintCream = Color(hex: "EEF4ED")

    // MARK: - Dark Mode Brand Colors (Lighter Variants)

    /// Sky Blue - Lightened Yale Blue for dark backgrounds
    static let skyBlue = Color(hex: "5B9BD5")

    /// Periwinkle - Lightened Oxford Navy for dark backgrounds
    static let periwinkle = Color(hex: "6C7B95")

    /// Steel Blue - Lightened Prussian Blue for dark backgrounds
    static let steelBlue = Color(hex: "4682B4")

    /// Light Powder Blue - Lightened Powder Blue for dark mode
    static let lightPowderBlue = Color(hex: "B4C7DC")

    /// Pale Mint - Lightened Mint Cream for dark mode
    static let paleMint = Color(hex: "C8E6C9")

    // MARK: - Complementary Semantic Colors (Light Mode)

    /// Sage Green - Fresh success color that complements cool blues
    static let sageGreen = Color(hex: "88B04B")

    /// Goldenrod - Warm warning color that pairs with navy
    static let goldenrod = Color(hex: "DAA520")

    /// Coral Red - Urgent but refined error color
    static let coralRed = Color(hex: "E74C3C")

    // MARK: - Complementary Semantic Colors (Dark Mode)

    /// Light Sage - Lighter success color for dark mode
    static let lightSage = Color(hex: "A8D08D")

    /// Light Gold - Brighter warning color for dark mode
    static let lightGold = Color(hex: "FFD54F")

    /// Light Coral - Vibrant error color for dark mode
    static let lightCoral = Color(hex: "FF6B6B")

    // MARK: - Adaptive Colors (Auto-switch based on color scheme)

    /// Adaptive primary color - Yale Blue (light) / Sky Blue (dark)
    public static var adaptivePrimary: Color {
        Color(light: .yaleBlue, dark: .skyBlue)
    }

    /// Adaptive secondary color - Oxford Navy (light) / Periwinkle (dark)
    public static var adaptiveSecondary: Color {
        Color(light: .oxfordNavy, dark: .periwinkle)
    }

    /// Adaptive accent color - Prussian Blue (light) / Steel Blue (dark)
    public static var adaptiveAccent: Color {
        Color(light: .prussianBlue, dark: .steelBlue)
    }

    /// Adaptive info color - Powder Blue (light) / Light Powder Blue (dark)
    public static var adaptiveInfo: Color {
        Color(light: .powderBlue, dark: .lightPowderBlue)
    }

    /// Adaptive success color - Sage Green (light) / Light Sage (dark)
    public static var adaptiveSuccess: Color {
        Color(light: .sageGreen, dark: .lightSage)
    }

    /// Adaptive warning color - Goldenrod (light) / Light Gold (dark)
    public static var adaptiveWarning: Color {
        Color(light: .goldenrod, dark: .lightGold)
    }

    /// Adaptive error color - Coral Red (light) / Light Coral (dark)
    public static var adaptiveError: Color {
        Color(light: .coralRed, dark: .lightCoral)
    }

    /// Adaptive tertiary background - Mint Cream (light) / Pale Mint (dark)
    public static var adaptiveTertiaryBackground: Color {
        Color(light: .mintCream, dark: .paleMint)
    }
}

// MARK: - Color Helper Extension

extension Color {
    /// Creates an adaptive color that changes based on light/dark mode
    init(light: Color, dark: Color) {
        self.init(uiColor: UIColor(dynamicProvider: { traitCollection in
            traitCollection.userInterfaceStyle == .dark ? UIColor(dark) : UIColor(light)
        }))
    }
}
