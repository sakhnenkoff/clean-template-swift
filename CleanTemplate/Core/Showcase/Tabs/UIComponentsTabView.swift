//
//  UIComponentsTabView.swift
//  CleanTemplate
//
//

import SwiftUI
import DesignSystem

struct UIComponentsTabView: View {

    @Bindable var presenter: ShowcasePresenter

    var body: some View {
        Section("DSButton - Styles") {
            VStack(alignment: .leading, spacing: DSSpacing.md) {
                DSButton(title: "Primary Button", style: .primary, isFullWidth: true) {
                    presenter.showToast("Primary tapped")
                }
                DSButton(title: "Secondary Button", style: .secondary, isFullWidth: true) {
                    presenter.showToast("Secondary tapped")
                }
                DSButton(title: "Tertiary Button", style: .tertiary, isFullWidth: true) {
                    presenter.showToast("Tertiary tapped")
                }
                DSButton(title: "Destructive Button", style: .destructive, isFullWidth: true) {
                    presenter.showToast("Destructive tapped")
                }
            }
            .listRowInsets(EdgeInsets(top: DSSpacing.md, leading: DSSpacing.md, bottom: DSSpacing.md, trailing: DSSpacing.md))
        }

        Section("DSButton - Sizes") {
            VStack(alignment: .leading, spacing: DSSpacing.sm) {
                Text("Small / Medium / Large")
                    .font(.captionLarge())
                    .foregroundStyle(Color.textSecondary)

                HStack(spacing: DSSpacing.sm) {
                    DSButton(title: "Small", size: .small) { }
                    DSButton(title: "Medium", size: .medium) { }
                    DSButton(title: "Large", size: .large) { }
                    Spacer()
                }
            }
            .listRowInsets(EdgeInsets(top: DSSpacing.md, leading: DSSpacing.md, bottom: DSSpacing.md, trailing: DSSpacing.md))
        }

        Section("DSButton - States") {
            VStack(alignment: .leading, spacing: DSSpacing.md) {
                DSButton(title: "With Icon", icon: "star.fill", isFullWidth: true) {
                    presenter.showToast("Icon button tapped")
                }

                DSButton.cta(title: "Full Width CTA") {
                    presenter.showToast("CTA tapped")
                }

                DSButton(title: "Loading State", isLoading: true, isFullWidth: true) { }

                DSButton(title: "Disabled State", isEnabled: false, isFullWidth: true) { }
            }
            .listRowInsets(EdgeInsets(top: DSSpacing.md, leading: DSSpacing.md, bottom: DSSpacing.md, trailing: DSSpacing.md))
        }

        Section("DSButton - Icon Only") {
            VStack(alignment: .leading, spacing: DSSpacing.sm) {
                Text("Small / Medium / Large + Styles")
                    .font(.captionLarge())
                    .foregroundStyle(Color.textSecondary)

                HStack(spacing: DSSpacing.md) {
                    DSIconButton(icon: "heart.fill", style: .primary, size: .small) {
                        presenter.showToast("Heart tapped")
                    }
                    DSIconButton(icon: "star.fill", style: .primary, size: .medium) {
                        presenter.showToast("Star tapped")
                    }
                    DSIconButton(icon: "bell.fill", style: .primary, size: .large) {
                        presenter.showToast("Bell tapped")
                    }
                    DSIconButton(icon: "plus", style: .secondary) {
                        presenter.showToast("Add tapped")
                    }
                    DSIconButton(icon: "xmark", style: .tertiary) {
                        presenter.showToast("Close tapped")
                    }
                    Spacer()
                }
            }
            .listRowInsets(EdgeInsets(top: DSSpacing.md, leading: DSSpacing.md, bottom: DSSpacing.md, trailing: DSSpacing.md))
        }

        Section("EmptyStateView") {
            VStack(spacing: DSSpacing.lg) {
                EmptyStateView(
                    icon: "folder",
                    title: "No Documents",
                    message: "Create your first document to get started",
                    actionTitle: "Create Document",
                    action: { presenter.showToast("Create tapped") }
                )

                Divider()

                EmptyStateView.noSearchResults(
                    query: "swift tutorials",
                    onClearSearch: { presenter.showToast("Clear search tapped") }
                )
            }
            .listRowInsets(EdgeInsets(top: DSSpacing.lg, leading: DSSpacing.md, bottom: DSSpacing.lg, trailing: DSSpacing.md))
        }

        Section("ErrorStateView") {
            VStack(spacing: DSSpacing.lg) {
                ErrorStateView.networkError(
                    onRetry: { presenter.showToast("Retry tapped") }
                )

                Divider()

                ErrorStateView(
                    title: "Upload Failed",
                    message: "Please check your connection and try again",
                    retryTitle: "Try Again",
                    onRetry: { presenter.showToast("Try again tapped") },
                    dismissTitle: "Cancel",
                    onDismiss: { presenter.showToast("Cancel tapped") }
                )
            }
            .listRowInsets(EdgeInsets(top: DSSpacing.lg, leading: DSSpacing.md, bottom: DSSpacing.lg, trailing: DSSpacing.md))
        }

        Section("SkeletonView - Shapes") {
            VStack(alignment: .leading, spacing: DSSpacing.md) {
                HStack(spacing: DSSpacing.md) {
                    SkeletonView(style: .circle(diameter: 50))
                    VStack(alignment: .leading, spacing: DSSpacing.sm) {
                        SkeletonView(style: .rectangle(width: 120, height: 16))
                        SkeletonView(style: .rectangle(width: 80, height: 12))
                    }
                }

                SkeletonView(style: .text(lines: 3, lastLineWidth: 0.6))
            }
            .listRowInsets(EdgeInsets(top: DSSpacing.md, leading: DSSpacing.md, bottom: DSSpacing.md, trailing: DSSpacing.md))
        }

        Section("SkeletonView - Presets") {
            VStack(spacing: DSSpacing.md) {
                Text("Avatar Sizes")
                    .font(.captionLarge())
                    .foregroundStyle(Color.textSecondary)
                    .frame(maxWidth: .infinity, alignment: .leading)

                HStack(spacing: DSSpacing.md) {
                    SkeletonView(style: .avatar(size: .small))
                    SkeletonView(style: .avatar(size: .medium))
                    SkeletonView(style: .avatar(size: .large))
                }

                Divider()

                Text("List Row")
                    .font(.captionLarge())
                    .foregroundStyle(Color.textSecondary)
                    .frame(maxWidth: .infinity, alignment: .leading)

                SkeletonView(style: .listRow)

                Divider()

                Text("Card")
                    .font(.captionLarge())
                    .foregroundStyle(Color.textSecondary)
                    .frame(maxWidth: .infinity, alignment: .leading)

                SkeletonView(style: .card)
            }
            .listRowInsets(EdgeInsets(top: DSSpacing.md, leading: DSSpacing.md, bottom: DSSpacing.md, trailing: DSSpacing.md))
        }

        Section("SkeletonView - Modifiers") {
            VStack(alignment: .leading, spacing: DSSpacing.md) {
                Text("Toggle loading to see effect:")
                    .font(.captionLarge())
                    .foregroundStyle(Color.textSecondary)

                Toggle("Show Skeleton", isOn: $presenter.showSkeletonDemo)

                HStack(spacing: DSSpacing.md) {
                    Circle()
                        .fill(Color.themePrimary)
                        .frame(width: 50, height: 50)
                        .skeleton(presenter.showSkeletonDemo, style: .circle(diameter: 50))

                    VStack(alignment: .leading, spacing: DSSpacing.xs) {
                        Text("John Appleseed")
                            .font(.headlineMedium())
                        Text("iOS Developer")
                            .font(.bodySmall())
                            .foregroundStyle(Color.textSecondary)
                    }
                    .shimmer(presenter.showSkeletonDemo)
                }
            }
            .listRowInsets(EdgeInsets(top: DSSpacing.md, leading: DSSpacing.md, bottom: DSSpacing.md, trailing: DSSpacing.md))
        }

        Section("Toast Notifications") {
            Button("Show Success Toast") {
                presenter.showSuccessToast()
            }

            Button("Show Error Toast") {
                presenter.showErrorToast()
            }

            Button("Show Warning Toast") {
                presenter.showWarningToast()
            }

            Button("Show Info Toast") {
                presenter.showInfoToast()
            }
        }

        Section("Loading Indicator") {
            Button("Show Loading (2s)") {
                presenter.showLoadingDemo()
            }
        }

        Section("Semantic Colors") {
            ColorRow(name: "Background Primary", color: .backgroundPrimary)
            ColorRow(name: "Background Secondary", color: .backgroundSecondary)
            ColorRow(name: "Accent", color: .themeAccent)
            ColorRow(name: "Text Primary", color: .textPrimary)
            ColorRow(name: "Text Secondary", color: .textSecondary)
        }

        Section("Typography") {
            Text("Title Large")
                .font(.titleLarge())
            Text("Title Medium")
                .font(.titleMedium())
            Text("Body Large")
                .font(.bodyLarge())
            Text("Body Medium")
                .font(.bodyMedium())
            Text("Body Small")
                .font(.bodySmall())
            Text("Button Large")
                .font(.buttonLarge())
            Text("Caption Large")
                .font(.captionLarge())
        }
    }
}

// MARK: - Reusable Components

struct ColorRow: View {
    let name: String
    let color: Color

    var body: some View {
        HStack {
            Text(name)

            Spacer()

            RoundedRectangle(cornerRadius: 6)
                .fill(color)
                .frame(width: 32, height: 32)
                .overlay(
                    RoundedRectangle(cornerRadius: 6)
                        .strokeBorder(Color.gray.opacity(0.3), lineWidth: 1)
                )
        }
    }
}

#Preview {
    PreviewRouter { router in
        let builder = DevPreview.builder
        List {
            UIComponentsTabView(
                presenter: ShowcasePresenter(
                    interactor: DevPreview.interactor,
                    router: CoreRouter(router: router, builder: builder)
                )
            )
        }
    }
}
