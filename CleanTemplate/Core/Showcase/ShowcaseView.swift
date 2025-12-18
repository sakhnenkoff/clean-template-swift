//
//  ShowcaseView.swift
//  CleanTemplate
//
//

import SwiftUI
import DesignSystem

// MARK: - Delegate

struct ShowcaseDelegate: Equatable, Hashable {

    var eventParameters: [String: Any] {
        [:]
    }

    static func == (lhs: ShowcaseDelegate, rhs: ShowcaseDelegate) -> Bool {
        true
    }

    func hash(into hasher: inout Hasher) { }
}

// MARK: - Tab Enum

enum ShowcaseTab: String, CaseIterable {
    case components = "UI"
    case managers = "Managers"
    case storage = "Storage"
    case navigation = "Navigation"

    var icon: String {
        switch self {
        case .components:   return "paintbrush.fill"
        case .managers:     return "gear"
        case .storage:      return "externaldrive.fill"
        case .navigation:   return "arrow.triangle.branch"
        }
    }
}

// MARK: - View

struct ShowcaseView: View {

    @State var presenter: ShowcasePresenter
    @State private var selectedTab: ShowcaseTab = .components

    let delegate: ShowcaseDelegate

    var body: some View {
        List {
            // Segmented Picker
            Section {
                Picker("", selection: $selectedTab) {
                    ForEach(ShowcaseTab.allCases, id: \.self) { tab in
                        Text(tab.rawValue).tag(tab)
                    }
                }
                .pickerStyle(.segmented)
                .listRowBackground(Color.clear)
                .listRowInsets(EdgeInsets())
            }

            // Tab Content
            tabContent(for: selectedTab)
        }
        .navigationTitle("Showcase")
        .toast($presenter.toast)
        .loading(presenter.isLoading)
        .onChange(of: selectedTab) { _, newTab in
            presenter.onTabChanged(to: newTab)
        }
        .onFirstAppear {
            presenter.onViewAppear(delegate: delegate)
        }
        .onDisappear {
            presenter.onViewDisappear(delegate: delegate)
        }
    }

    @ViewBuilder
    private func tabContent(for tab: ShowcaseTab) -> some View {
        switch tab {
        case .components:
            UIComponentsTabView(presenter: presenter)
        case .managers:
            ManagersTabView(presenter: presenter)
        case .storage:
            StorageTabView(presenter: presenter)
        case .navigation:
            NavigationTabView(presenter: presenter)
        }
    }
}

// MARK: - CoreBuilder Extension

extension CoreBuilder {

    func showcaseView(router: AnyRouter, delegate: ShowcaseDelegate) -> some View {
        ShowcaseView(
            presenter: ShowcasePresenter(
                interactor: interactor,
                router: CoreRouter(router: router, builder: self)
            ),
            delegate: delegate
        )
    }
}

#Preview {
    let container = DevPreview.shared.container()
    let interactor = CoreInteractor(container: container)
    let builder = CoreBuilder(interactor: interactor)

    return RouterView { router in
        builder.showcaseView(router: router, delegate: ShowcaseDelegate())
    }
}
