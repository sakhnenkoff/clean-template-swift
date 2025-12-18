import SwiftUI

/// Defines a single text style with all its attributes
public struct TextStyle: Sendable {
    public let font: Font
    public let size: CGFloat
    public let weight: Font.Weight

    public init(
        size: CGFloat,
        weight: Font.Weight,
        customFont: String? = nil
    ) {
        self.size = size
        self.weight = weight

        if let customFont {
            self.font = .custom(customFont, size: size).weight(weight)
        } else {
            self.font = .system(size: size, weight: weight)
        }
    }
}

/// Typography scale with all text styles
public struct TypographyScale: Sendable {

    // MARK: - Title Styles

    public let titleLarge: TextStyle
    public let titleMedium: TextStyle
    public let titleSmall: TextStyle

    // MARK: - Headline Styles

    public let headlineLarge: TextStyle
    public let headlineMedium: TextStyle
    public let headlineSmall: TextStyle

    // MARK: - Body Styles

    public let bodyLarge: TextStyle
    public let bodyMedium: TextStyle
    public let bodySmall: TextStyle

    // MARK: - Caption Styles

    public let captionLarge: TextStyle
    public let captionSmall: TextStyle

    // MARK: - Button Styles

    public let buttonLarge: TextStyle
    public let buttonMedium: TextStyle
    public let buttonSmall: TextStyle

    // MARK: - Init

    public init(
        titleLarge: TextStyle,
        titleMedium: TextStyle,
        titleSmall: TextStyle,
        headlineLarge: TextStyle,
        headlineMedium: TextStyle,
        headlineSmall: TextStyle,
        bodyLarge: TextStyle,
        bodyMedium: TextStyle,
        bodySmall: TextStyle,
        captionLarge: TextStyle,
        captionSmall: TextStyle,
        buttonLarge: TextStyle,
        buttonMedium: TextStyle,
        buttonSmall: TextStyle
    ) {
        self.titleLarge = titleLarge
        self.titleMedium = titleMedium
        self.titleSmall = titleSmall
        self.headlineLarge = headlineLarge
        self.headlineMedium = headlineMedium
        self.headlineSmall = headlineSmall
        self.bodyLarge = bodyLarge
        self.bodyMedium = bodyMedium
        self.bodySmall = bodySmall
        self.captionLarge = captionLarge
        self.captionSmall = captionSmall
        self.buttonLarge = buttonLarge
        self.buttonMedium = buttonMedium
        self.buttonSmall = buttonSmall
    }
}
