//
//  NavigationTabView.swift
//  CleanTemplate
//
//

import SwiftUI
import DesignSystem

struct NavigationTabView: View {

    @Bindable var presenter: ShowcasePresenter

    var body: some View {
        Section("Screen Transitions") {
            Button {
                presenter.showPushDemo()
            } label: {
                Label("Push Navigation", systemImage: "arrow.right.square.fill")
            }

            Button {
                presenter.showSheetDemo()
            } label: {
                Label("Sheet Presentation", systemImage: "rectangle.bottomhalf.inset.filled")
            }

            Button {
                presenter.showFullScreenDemo()
            } label: {
                Label("Full Screen Cover", systemImage: "rectangle.inset.filled")
            }
        }

        Section("Alerts") {
            Button {
                presenter.showSimpleAlert()
            } label: {
                Label("Simple Alert", systemImage: "exclamationmark.circle.fill")
            }

            Button {
                presenter.showCustomAlert()
            } label: {
                Label("Custom Alert", systemImage: "questionmark.circle.fill")
            }
        }

        Section {
            Button {
                presenter.switchToOnboarding()
            } label: {
                Label("Switch to Onboarding", systemImage: "arrow.triangle.swap")
            }
        } header: {
            Text("Module Switching")
        } footer: {
            Text("Switch between app modules (Onboarding ↔ Main App)")
        }
    }
}

#Preview {
    let container = DevPreview.shared.container()
    let interactor = CoreInteractor(container: container)
    let builder = CoreBuilder(interactor: interactor)

    return RouterView { router in
        List {
            NavigationTabView(
                presenter: ShowcasePresenter(
                    interactor: interactor,
                    router: CoreRouter(router: router, builder: builder)
                )
            )
        }
    }
}
