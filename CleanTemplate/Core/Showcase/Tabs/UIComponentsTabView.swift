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
    let container = DevPreview.shared.container()
    let interactor = CoreInteractor(container: container)
    let builder = CoreBuilder(interactor: interactor)

    return RouterView { router in
        List {
            UIComponentsTabView(
                presenter: ShowcasePresenter(
                    interactor: interactor,
                    router: CoreRouter(router: router, builder: builder)
                )
            )
        }
    }
}
