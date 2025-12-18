//
//  ManagersTabView.swift
//  CleanTemplate
//
//

import SwiftUI
import DesignSystem

struct ManagersTabView: View {

    @Bindable var presenter: ShowcasePresenter

    var body: some View {
        Section("Authentication") {
            LabeledContent("Signed In", value: presenter.isSignedIn ? "Yes" : "No")

            if let auth = presenter.auth {
                LabeledContent("User ID", value: String(auth.uid.prefix(12)) + "...")
                LabeledContent("Email", value: auth.email ?? "None")
                LabeledContent("Anonymous", value: auth.isAnonymous ? "Yes" : "No")
            }

            if let user = presenter.currentUser {
                LabeledContent("Display Name", value: user.displayName ?? "Not set")
            }
        }

        Section("Streaks") {
            LabeledContent("Current Streak", value: "\(presenter.currentStreakData?.currentStreak ?? 0) days")
            LabeledContent("Longest Streak", value: "\(presenter.currentStreakData?.longestStreak ?? 0) days")

            Button("Add Streak Event") {
                Task {
                    await presenter.addStreakEvent()
                }
            }
        }

        Section("Experience Points") {
            LabeledContent("Total XP", value: "\(presenter.currentXPData?.pointsAllTime ?? 0) pts")

            Button("Add 10 XP") {
                Task {
                    await presenter.addXPPoints(10)
                }
            }
            Button("Add 50 XP") {
                Task {
                    await presenter.addXPPoints(50)
                }
            }
        }

        Section("Progress") {
            LabeledContent("Progress Items", value: "\(presenter.allProgressItems.count)")
        }

        Section("Purchases") {
            LabeledContent("Premium Status", value: presenter.isPremium ? "Active" : "Free")
            LabeledContent("Entitlements", value: "\(presenter.entitlements.count)")
        }

        Section("Haptic Feedback") {
            Button("Light") { presenter.triggerHaptic(.light) }
            Button("Medium") { presenter.triggerHaptic(.medium) }
            Button("Heavy") { presenter.triggerHaptic(.heavy) }
            Button("Success") { presenter.triggerHaptic(.success) }
            Button("Warning") { presenter.triggerHaptic(.warning) }
            Button("Error") { presenter.triggerHaptic(.error) }
        }

        Section("Sound Effects") {
            Button("Play Sample Sound") {
                presenter.playSampleSound()
            }
        }

        Section("Push Notifications") {
            Button("Request Permission") {
                Task {
                    await presenter.requestPushPermission()
                }
            }
        }
    }
}

#Preview {
    let container = DevPreview.shared.container()
    let interactor = CoreInteractor(container: container)
    let builder = CoreBuilder(interactor: interactor)

    return RouterView { router in
        List {
            ManagersTabView(
                presenter: ShowcasePresenter(
                    interactor: interactor,
                    router: CoreRouter(router: router, builder: builder)
                )
            )
        }
    }
}
