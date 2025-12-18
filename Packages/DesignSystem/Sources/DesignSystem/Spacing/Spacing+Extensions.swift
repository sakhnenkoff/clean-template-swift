import SwiftUI

/// Spacing namespace for consistent layout values
public enum DSSpacing {
    /// Extra small spacing (default: 4pt)
    public static var xs: CGFloat { DesignSystem.spacing.xs }
    /// Small spacing (default: 8pt)
    public static var sm: CGFloat { DesignSystem.spacing.sm }
    /// Medium spacing (default: 16pt)
    public static var md: CGFloat { DesignSystem.spacing.md }
    /// Large spacing (default: 24pt)
    public static var lg: CGFloat { DesignSystem.spacing.lg }
    /// Extra large spacing (default: 32pt)
    public static var xl: CGFloat { DesignSystem.spacing.xl }
    /// Extra extra large spacing (default: 48pt)
    public static var xxl: CGFloat { DesignSystem.spacing.xxl }
}
