//
//  StorageTabView.swift
//  CleanTemplate
//
//

import SwiftUI
import DesignSystem

struct StorageTabView: View {

    @Bindable var presenter: ShowcasePresenter
    @State private var keychainInput: String = ""
    @State private var userDefaultsInput: String = ""

    var body: some View {
        Section("Keychain (Secure)") {
            TextField("Enter value to store", text: $keychainInput)

            HStack {
                Button("Save") {
                    presenter.saveToKeychain(keychainInput)
                }
                .buttonStyle(.borderedProminent)
                .tint(Color.success)

                Button("Fetch") {
                    presenter.fetchFromKeychain()
                }
                .buttonStyle(.borderedProminent)
                .tint(Color.link)

                Button("Delete") {
                    presenter.deleteFromKeychain()
                }
                .buttonStyle(.borderedProminent)
                .tint(Color.destructive)
            }

            if let value = presenter.keychainTestValue {
                LabeledContent("Stored Value", value: value)
            }
        }

        Section("UserDefaults") {
            TextField("Enter value to store", text: $userDefaultsInput)

            HStack {
                Button("Save") {
                    presenter.saveToUserDefaults(userDefaultsInput)
                }
                .buttonStyle(.borderedProminent)
                .tint(Color.success)

                Button("Fetch") {
                    presenter.fetchFromUserDefaults()
                }
                .buttonStyle(.borderedProminent)
                .tint(Color.link)

                Button("Delete") {
                    presenter.deleteFromUserDefaults()
                }
                .buttonStyle(.borderedProminent)
                .tint(Color.destructive)
            }

            if let value = presenter.userDefaultsTestValue {
                LabeledContent("Stored Value", value: value)
            }
        }

        Section("User Data Sync") {
            LabeledContent("Sync Status", value: presenter.isSignedIn ? "Active" : "Not signed in")

            if let user = presenter.currentUser {
                LabeledContent("User ID", value: String(user.id.prefix(12)) + "...")
                LabeledContent("Display Name", value: user.displayName ?? "Not set")
                LabeledContent("Email", value: user.email ?? "Not set")
                if let createdAt = user.creationDate {
                    LabeledContent("Created", value: createdAt.formatted(date: .abbreviated, time: .omitted))
                }
            }
        }
    }
}

#Preview {
    PreviewRouter { router in
        let builder = DevPreview.builder
        List {
            StorageTabView(
                presenter: ShowcasePresenter(
                    interactor: DevPreview.interactor,
                    router: CoreRouter(router: router, builder: builder)
                )
            )
        }
    }
}
