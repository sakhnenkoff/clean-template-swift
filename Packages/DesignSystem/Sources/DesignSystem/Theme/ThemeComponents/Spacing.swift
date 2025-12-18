import SwiftUI

/// Spacing scale for consistent layout
public struct SpacingScale: Sendable {

    /// Extra small: 4pt default
    public let xs: CGFloat

    /// Small: 8pt default
    public let sm: CGFloat

    /// Medium: 16pt default
    public let md: CGFloat

    /// Large: 24pt default
    public let lg: CGFloat

    /// Extra large: 32pt default
    public let xl: CGFloat

    /// Extra extra large: 48pt default
    public let xxl: CGFloat

    public init(
        xs: CGFloat,
        sm: CGFloat,
        md: CGFloat,
        lg: CGFloat,
        xl: CGFloat,
        xxl: CGFloat
    ) {
        self.xs = xs
        self.sm = sm
        self.md = md
        self.lg = lg
        self.xl = xl
        self.xxl = xxl
    }
}
