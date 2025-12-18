import SwiftUI

/// Main theme protocol that aggregates all design tokens
public protocol Theme: Sendable {
    var colors: ColorPalette { get }
    var typography: TypographyScale { get }
    var spacing: SpacingScale { get }
}
