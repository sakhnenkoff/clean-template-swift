//
//  PreviewHelpers.swift
//  CleanTemplate
//
//  Convenience utilities for SwiftUI previews.
//  Simplifies preview setup by providing quick access to common dependencies.
//

import SwiftUI
import SwiftfulRouting
import DesignSystem

// MARK: - DevPreview Extensions

extension DevPreview {

    /// Pre-built CoreInteractor for previews.
    /// Use this instead of manually creating container and interactor.
    static var interactor: CoreInteractor {
        CoreInteractor(container: shared.container())
    }

    /// Pre-built CoreBuilder for previews.
    /// Use this to build any screen in previews.
    static var builder: CoreBuilder {
        CoreBuilder(interactor: interactor)
    }
}

// MARK: - Preview Router Wrapper

/// A wrapper that provides a RouterView with a router parameter for previews.
/// Simplifies preview setup for screens that need a router.
///
/// Usage:
/// ```swift
/// #Preview {
///     PreviewRouter { router in
///         DevPreview.builder.homeView(router: router, delegate: HomeDelegate())
///     }
/// }
/// ```
struct PreviewRouter<Content: View>: View {
    let content: (AnyRouter) -> Content

    init(@ViewBuilder content: @escaping (AnyRouter) -> Content) {
        self.content = content
    }

    var body: some View {
        RouterView { router in
            content(router)
        }
    }
}

// MARK: - Preview State Wrapper

/// A wrapper for previewing views that need @State bindings.
///
/// Usage:
/// ```swift
/// #Preview {
///     PreviewState(initialValue: "Hello") { binding in
///         TextField("Name", text: binding)
///     }
/// }
/// ```
struct PreviewState<Value, Content: View>: View {
    @State private var value: Value
    let content: (Binding<Value>) -> Content

    init(initialValue: Value, @ViewBuilder content: @escaping (Binding<Value>) -> Content) {
        self._value = State(initialValue: initialValue)
        self.content = content
    }

    var body: some View {
        content($value)
    }
}

// MARK: - Preview Container

/// A container that wraps content with common preview configurations.
/// Useful for testing components with consistent styling.
///
/// Usage:
/// ```swift
/// #Preview {
///     PreviewContainer {
///         MyComponentView(title: "Hello")
///     }
/// }
/// ```
struct PreviewContainer<Content: View>: View {
    let backgroundColor: Color
    let padding: CGFloat
    let content: () -> Content

    init(
        backgroundColor: Color = .backgroundPrimary,
        padding: CGFloat = DSSpacing.md,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.backgroundColor = backgroundColor
        self.padding = padding
        self.content = content
    }

    var body: some View {
        content()
            .padding(padding)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(backgroundColor)
    }
}

// MARK: - Preview Device Sizes

/// Common device preview configurations.
enum PreviewDevice: String, CaseIterable {
    case iPhoneSE = "iPhone SE (3rd generation)"
    case iPhone15 = "iPhone 15"
    case iPhone15Pro = "iPhone 15 Pro"
    case iPhone15ProMax = "iPhone 15 Pro Max"
    case iPadMini = "iPad mini (6th generation)"
    case iPadPro11 = "iPad Pro (11-inch) (4th generation)"
    case iPadPro13 = "iPad Pro (12.9-inch) (6th generation)"
}

// MARK: - Usage Examples
/*
 // BEFORE (verbose preview setup):

 #Preview {
     let container = DevPreview.shared.container()
     let interactor = CoreInteractor(container: container)
     let builder = CoreBuilder(interactor: interactor)

     return RouterView { router in
         builder.homeView(router: router, delegate: HomeDelegate())
     }
 }

 // AFTER (simple preview setup):

 #Preview {
     PreviewRouter { router in
         DevPreview.builder.homeView(router: router, delegate: HomeDelegate())
     }
 }

 // For components (without router):

 #Preview {
     PreviewContainer {
         MyComponentView(title: "Hello", onTap: nil)
     }
 }

 // For views with state:

 #Preview {
     PreviewState(initialValue: false) { isOn in
         Toggle("Enabled", isOn: isOn)
     }
 }

 // Multi-state previews:

 #Preview("Light Mode") {
     PreviewContainer {
         MyComponentView()
     }
 }

 #Preview("Dark Mode") {
     PreviewContainer {
         MyComponentView()
     }
     .preferredColorScheme(.dark)
 }
 */
