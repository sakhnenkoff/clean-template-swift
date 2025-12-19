# VIPER Layer Rules & UI Guidelines

These are **CRITICAL** rules for building UI and working with the VIPER architecture. **ALWAYS follow these rules** when adding or modifying screens and components.

---

## 📱 Screen Views (VIPER Pattern)

Screen views follow the VIPER pattern and have different rules than reusable components.

**What Screen Views CAN use:**
- ✅ `@State` to hold the Presenter
- ✅ `@State` for local UI state (sheet presentation, alert state, animation state, etc.)
- ✅ Call Presenter methods for business logic
- ✅ Display data from Presenter's `@Observable` properties
- ✅ Use any layout/UI components
- ✅ **ALWAYS use `.anyButton()` or `.asButton()` modifier** instead of `Button()` wrapper

**What Screen Views CANNOT use:**
- ❌ **NO direct manager access** - always go through Presenter → Interactor → Manager
- ❌ **NO business logic** in the view - all logic goes in Presenter
- ❌ **NO network calls** or data persistence - use Interactor/Manager
- ❌ `@StateObject` or `@ObservedObject` (use `@State` with `@Observable` Presenter instead)
- ❌ **NEVER use `onTapGesture` for interactive elements** - always use `Button` (see Button Usage Rules below)

**Example Screen View:**
```swift
struct HomeView: View {
    @State var presenter: HomePresenter
    @State private var showAlert: Bool = false  // Local UI state is OK

    var body: some View {
        VStack {
            // Display data from presenter
            Text(presenter.title)

            Button("Do Something") {
                // Call presenter for business logic
                presenter.onButtonTapped()
            }

            Button("Show Alert") {
                // Local UI state changes are OK
                showAlert = true
            }
        }
        .alert("Message", isPresented: $showAlert) {
            Button("OK") { }
        }
        .onAppear {
            presenter.onViewAppear()
        }
    }
}
```

---

## 🧩 Reusable Components

Components are **DUMB UI** - they only display data and call callbacks. All business logic stays in Presenters.

**CRITICAL Component Rules:**
- ✅ **NO business logic** - UI only
- ✅ **NO @State** for data (only for UI animations/transitions like button press states)
- ✅ **NO @Observable objects** or Presenters
- ✅ **NO @StateObject or @ObservedObject**
- ✅ **ALL data is injected** via init parameters
- ✅ **Make properties OPTIONAL** - then unwrap in the body for maximum flexibility
- ✅ **ALL loading/error states are injected** as parameters (Bool, enum, or other types)
- ✅ **ALL actions are closures** (e.g., `onTap: (() -> Void)?`, `onSubmit: ((String) -> Void)?`)
- ✅ **ALWAYS use `.anyButton()` or `.asButton()` modifier** instead of `Button()` wrapper
- ✅ **ALWAYS use ImageLoaderView** for images (never AsyncImage unless specifically requested)
- ✅ **Create MULTIPLE #Previews** showing different states (full data, partial data, no data, loading, empty)

**Example Component:**
```swift
struct ProfileCardView: View {
    // All data injected - make optional for flexibility
    let imageUrl: String?
    let title: String?
    let subtitle: String?
    let isLoading: Bool

    // All actions as closures
    let onTap: (() -> Void)?

    var body: some View {
        VStack(spacing: 8) {
            // Unwrap optionals in the view
            if isLoading {
                ProgressView()
            } else {
                if let imageUrl {
                    ImageLoaderView(urlString: imageUrl)
                        .aspectRatio(1, contentMode: .fill)
                }

                if let title {
                    Text(title)
                }

                if let subtitle {
                    Text(subtitle)
                }
            }
        }
        .onTapGesture {
            onTap?()
        }
    }
}

#Preview("Full Data") {
    ProfileCardView(
        imageUrl: "https://picsum.photos/100",
        title: "John Doe",
        subtitle: "Developer",
        isLoading: false,
        onTap: { print("Tapped") }
    )
}

#Preview("Loading") {
    ProfileCardView(
        imageUrl: nil,
        title: nil,
        subtitle: nil,
        isLoading: true,
        onTap: nil
    )
}

#Preview("Partial Data") {
    ProfileCardView(
        imageUrl: nil,
        title: "Jane Smith",
        subtitle: nil,
        isLoading: false,
        onTap: nil
    )
}
```

---

## 🔘 Button Usage Rules

**CRITICAL: NEVER use `onTapGesture` for interactive elements that should be buttons.**

### Why This Matters

Using `onTapGesture` instead of `Button` breaks:
- ❌ **Accessibility** - VoiceOver users cannot interact properly
- ❌ **Visual feedback** - No tap highlight or press state
- ❌ **Keyboard navigation** - Cannot be focused or activated via keyboard
- ❌ **System button behaviors** - No automatic disabled states, loading states, etc.

### Correct Button Usage

```swift
// ✅ CORRECT - Use Button
Button("Submit") {
    presenter.onSubmitTapped()
}

// ✅ CORRECT - Button with custom label
Button {
    presenter.onItemTapped()
} label: {
    Label("Settings", systemImage: "gear")
}

// ✅ CORRECT - Use .anyButton() or .asButton() modifier
Text("Tap Me")
    .anyButton(.press) {
        presenter.onTapped()
    }
```

### Incorrect Usage

```swift
// ❌ WRONG - Never use onTapGesture for buttons
Text("Submit")
    .onTapGesture {
        presenter.onSubmitTapped()
    }

// ❌ WRONG - Never use onTapGesture for interactive elements
Label("Settings", systemImage: "gear")
    .onTapGesture {
        presenter.openSettings()
    }
```

### List Button Behavior

In SwiftUI `List`, buttons expand their tap area to fill the entire row. This is **expected behavior** for accessibility and usability:

```swift
// This is CORRECT - the full row being tappable is intentional
List {
    Section("Actions") {
        Button("Action 1") { presenter.action1() }
        Button("Action 2") { presenter.action2() }
    }
}
```

If you need multiple interactive elements in a single list row, structure them appropriately:

```swift
// Multiple buttons in one row - use HStack
List {
    HStack {
        Button("Edit") { presenter.edit() }
        Spacer()
        Button("Delete") { presenter.delete() }
            .foregroundStyle(Color.destructive)
    }
}
```

---

## 🎯 Presenter Layer Rules

Presenters contain **ALL business logic** for a screen.

**What Presenters DO:**
- ✅ Hold all screen state as `@Observable` properties
- ✅ Contain ALL business logic
- ✅ Call Interactor for data operations
- ✅ Call Router for navigation
- ✅ Transform data for display (e.g., formatting, filtering)
- ✅ Track analytics events
- ✅ Handle user actions (button taps, form submissions, etc.)
- ✅ Manage loading/error states

**What Presenters DON'T DO:**
- ❌ **NO direct manager access** - use Interactor
- ❌ **NO direct navigation** - use Router
- ❌ **NO UI code** - that stays in View

**CRITICAL Presenter Rules:**
- ✅ **ANY action from the View MUST trigger a method in the Presenter** - Never put business logic directly in button closures
- ✅ **ALL Presenter methods MUST have analytics tracking** - Use `interactor.trackEvent(event: Event.methodName)` in every user-facing method

**Example Presenter:**
```swift
@Observable
@MainActor
class HomePresenter {
    let router: any HomeRouter
    let interactor: any HomeInteractor

    // All screen state lives here
    var title: String = ""
    var isLoading: Bool = false
    var errorMessage: String?

    init(router: any HomeRouter, interactor: any HomeInteractor) {
        self.router = router
        self.interactor = interactor
    }

    // Business logic methods
    func onViewAppear() {
        Task {
            await loadData()
        }
    }

    func onButtonTapped() {
        // Business logic here
        isLoading = true

        Task {
            do {
                try await interactor.performAction()
                router.showNextScreen()
            } catch {
                errorMessage = error.localizedDescription
            }
            isLoading = false
        }
    }

    private func loadData() async {
        // Use interactor for data
        let data = await interactor.fetchData()
        title = data.title
    }
}
```

---

## 🧭 Router Layer Rules

Routers handle **ALL navigation** for a screen.

**What Routers DO:**
- ✅ Define navigation methods as protocol
- ✅ Implemented by CoreRouter
- ✅ Use SwiftfulRouting's `router.showScreen()` methods
- ✅ Manage presentation style (.push, .sheet, .fullScreenCover)

**What Routers DON'T DO:**
- ❌ **NO business logic** - only navigation
- ❌ **NO data access** - only screen transitions

**CRITICAL Router Rules:**
- ✅ **ALL routing MUST use SwiftfulRouting** (https://github.com/SwiftfulThinking/SwiftfulRouting)
- ✅ This includes: segues, modals, alerts, transitions, and switching modules
- ✅ Use `router.showScreen()` for navigation (.push, .sheet, .fullScreenCover)
- ✅ Use `router.showAlert()` for alerts
- ✅ Use `router.dismissScreen()` or `router.dismissEnvironment()` for dismissals
- ✅ Use `router.showModule(moduleId)` for switching between modules (e.g., onboarding ↔ tabbar)
- ✅ **ALWAYS check for existing router methods before creating new ones** - Use grep to search for `func show[ScreenName]` across the codebase
- ✅ **Router protocol must declare ALL methods the screen needs** - Even if implementation exists in CoreRouter extension elsewhere, add method signature to the screen's Router protocol
- ✅ **CoreRouter extensions can exist in ANY file** - Implementation of `showPaywallView()` is in PaywallView.swift, but MUST be declared in HomeRouter protocol for Home to use it
- ✅ **NEVER duplicate CoreRouter extension implementations** - Reuse existing implementations, but DO add method signatures to each Router protocol that needs them
- ✅ **Alert button callbacks MUST use `@MainActor @Sendable`** - When passing presenter methods to alert buttons, closure parameters must be `@escaping @MainActor @Sendable () -> Void` (not just `@Sendable`) to preserve the MainActor context

**Example Router:**
```swift
// Protocol
protocol HomeRouter: GlobalRouter {
    func showDetailScreen(id: String)
    func showSettings()
    func showAlertWithCallback(onConfirm: @escaping @MainActor @Sendable () -> Void)
}

// Implementation in CoreRouter
extension CoreRouter: HomeRouter {
    func showDetailScreen(id: String) {
        router.showScreen(.push) { router in
            builder.detailView(router: router, delegate: DetailDelegate(id: id))
        }
    }

    func showSettings() {
        router.showScreen(.sheet) { router in
            builder.settingsView(router: router)
        }
    }

    // Alert with callback - closure MUST be @MainActor @Sendable
    func showAlertWithCallback(onConfirm: @escaping @MainActor @Sendable () -> Void) {
        showAlert(.alert, title: "Confirm?", subtitle: nil) {
            AnyView(
                Button("Confirm") {
                    onConfirm()  // This calls presenter method which is @MainActor
                }
            )
        }
    }
}

// Usage in Presenter
@Observable
@MainActor
class HomePresenter {
    func onButtonTapped() {
        router.showAlertWithCallback(onConfirm: onAlertConfirmed)
    }

    func onAlertConfirmed() {  // This is @MainActor (inherited from class)
        // Do something
    }
}
```

---

## 📊 Interactor Layer Rules

Interactors handle **ALL data access** for a screen.

**What Interactors DO:**
- ✅ Define data access methods as protocol
- ✅ Implemented by CoreInteractor
- ✅ Access managers via DependencyContainer
- ✅ Perform data operations (fetch, save, delete)
- ✅ Track analytics events

**What Interactors DON'T DO:**
- ❌ **NO UI logic** - only data operations
- ❌ **NO navigation** - only data
- ❌ **NO business logic** - that's in Presenter (Interactor just fetches/saves data)

**Example Interactor:**
```swift
// Protocol
protocol HomeInteractor: GlobalInteractor {
    var currentUser: UserObject? { get }
    func fetchData() async -> [Item]
    func saveItem(_ item: Item) async throws
}

// Implementation in CoreInteractor
extension CoreInteractor: HomeInteractor {
    var currentUser: UserObject? {
        container.resolve(UserManager.self)!.currentUser
    }

    func fetchData() async -> [Item] {
        // Access manager for data
        await container.resolve(DataManager.self)!.fetchItems()
    }

    func saveItem(_ item: Item) async throws {
        try await container.resolve(DataManager.self)!.save(item)
    }
}
```

---

## 📐 Layout Best Practices

**✅ PREFERRED - Use maxWidth/maxHeight with alignment:**
```swift
VStack(spacing: 8) {
    Text("Title")
        .frame(maxWidth: .infinity, alignment: .leading)

    Text("Description")
        .frame(maxWidth: .infinity, alignment: .leading)

    HStack {
        Text("Left")
            .frame(maxWidth: .infinity, alignment: .leading)

        Text("Right")
            .frame(maxWidth: .infinity, alignment: .trailing)
    }
}
```

**❌ AVOID - Using Spacer():**
```swift
// Don't do this
VStack(spacing: 8) {
    HStack {
        Text("Title")
        Spacer()  // ❌ Avoid
    }

    HStack {
        Text("Description")
        Spacer()  // ❌ Avoid
    }
}
```

**Other Layout Rules:**
- ✅ **AVOID fixed frames** when possible - let SwiftUI handle sizing naturally
- ✅ Use `.fixedSize()` sparingly and only when necessary
- ✅ Let SwiftUI's natural sizing work for you
- ✅ Use spacing parameters in stacks instead of padding when possible

---

## 🎨 Color Usage Rules

**CRITICAL: NEVER use hardcoded SwiftUI colors. ALWAYS use DesignSystem tokens.**

### Forbidden - Never Use These:
- ❌ `Color.red`, `Color.blue`, `Color.green`, `Color.yellow`, `Color.orange`
- ❌ `Color.white`, `Color.black` (except in DesignSystem package internals)
- ❌ `Color(uiColor: .systemBackground)` - use `.backgroundPrimary` instead
- ❌ `Color(hex: "...")` in view files - define in DesignSystem instead
- ❌ `.foregroundStyle(.red)`, `.foregroundStyle(.blue)`, etc.
- ❌ `.tint(.green)`, `.tint(.red)`, etc.

### Required - Always Use DesignSystem Tokens:

| Use Case | DesignSystem Token |
|----------|-------------------|
| Brand/accent color | `Color.themeAccent` |
| Primary brand color | `Color.themePrimary` |
| Error/delete actions | `Color.destructive` |
| Success states | `Color.success` |
| Warning states | `Color.warning` |
| Info/links | `Color.link` |
| Primary background | `Color.backgroundPrimary` |
| Secondary background | `Color.backgroundSecondary` |
| Primary text | `Color.textPrimary` |
| Muted/secondary text | `.foregroundStyle(.secondary)` (SwiftUI semantic) OR `Color.textSecondary` |
| Text on dark/accent backgrounds | `Color.textOnPrimary` |
| Text on accent backgrounds | `Color.textOnAccent` |
| Borders | `Color.border` |
| Dividers | `Color.divider` |
| Modal/overlay backgrounds | `Color.overlayBackground` |

### Examples:

```swift
// ❌ WRONG
Text("Delete").foregroundStyle(.red)
Button("Link").foregroundStyle(.blue)
VStack { }.background(Color.white)
.tint(.green)

// ✅ CORRECT
Text("Delete").foregroundStyle(Color.destructive)
Button("Link").foregroundStyle(Color.link)
VStack { }.background(Color.backgroundPrimary)
.tint(Color.success)
```

### Button Color Patterns:

```swift
// Delete/Destructive buttons
Button("Delete")
    .tint(Color.destructive)

// Success/Save buttons
Button("Save")
    .tint(Color.success)

// Link/Info buttons
Button("Learn More")
    .tint(Color.link)

// Text on accent-colored backgrounds
Text("Submit")
    .foregroundStyle(Color.textOnPrimary)
    .background(Color.themeAccent)
```

### Note on `.secondary`:
SwiftUI's `.foregroundStyle(.secondary)` is acceptable for muted text because it's a semantic color that adapts to light/dark mode. Our `Color.textSecondary` maps to the same value.

---

## 📏 Spacing Usage Rules

**CRITICAL: NEVER use hardcoded spacing values. ALWAYS use DSSpacing tokens.**

### Forbidden - Never Use These:
- ❌ `.padding(8)`, `.padding(16)`, `.padding(24)`, etc.
- ❌ `VStack(spacing: 12)`, `HStack(spacing: 8)`, etc.
- ❌ `.cornerRadius(16)`, `.cornerRadius(12)`, etc.
- ❌ `.frame(width: 4, height: 4)` for spacing elements
- ❌ Any hardcoded CGFloat for padding, spacing, or corner radius

### Required - Always Use DSSpacing Tokens:

| Value | DSSpacing Token | Common Use Cases |
|-------|-----------------|------------------|
| 4pt | `DSSpacing.xs` | Tiny gaps, icon spacing, small decorative elements |
| 8pt | `DSSpacing.sm` | Compact spacing, button internal padding |
| 12pt | `DSSpacing.smd` | Toast padding, list row spacing, corner radius |
| 16pt | `DSSpacing.md` | Standard padding, modal content padding |
| 20pt | `DSSpacing.mlg` | Medium-large gaps |
| 24pt | `DSSpacing.lg` | Section spacing, card padding |
| 32pt | `DSSpacing.xl` | Large section gaps |
| 40pt | `DSSpacing.xxlg` | Extra large spacing, top padding for modals |
| 48pt | `DSSpacing.xxl` | Maximum spacing, major sections |

### Examples:

```swift
// ❌ WRONG
VStack(spacing: 8) { }
.padding(16)
.padding(.horizontal, 24)
.cornerRadius(12)
.frame(width: 4, height: 4)

// ✅ CORRECT
VStack(spacing: DSSpacing.sm) { }
.padding(DSSpacing.md)
.padding(.horizontal, DSSpacing.lg)
.cornerRadius(DSSpacing.smd)
.frame(width: DSSpacing.xs, height: DSSpacing.xs)
```

### Common Patterns:

```swift
// Stack spacing
VStack(spacing: DSSpacing.sm) { }      // 8pt - compact
VStack(spacing: DSSpacing.smd) { }     // 12pt - comfortable
VStack(spacing: DSSpacing.lg) { }      // 24pt - spacious

// Padding
.padding(DSSpacing.md)                  // 16pt - standard content padding
.padding(.horizontal, DSSpacing.lg)     // 24pt - horizontal margins
.padding(.top, DSSpacing.xxlg)          // 40pt - large top spacing

// Corner radius
.cornerRadius(DSSpacing.smd)            // 12pt - cards, buttons
.cornerRadius(DSSpacing.md)             // 16pt - larger elements

// Safe area insets
.safeAreaInset(edge: .bottom) {
    content
        .padding(DSSpacing.lg)          // 24pt
}
```

### Importing DSSpacing:

Always import DesignSystem to access DSSpacing tokens:

```swift
import SwiftUI
import DesignSystem  // Required for DSSpacing

struct MyView: View {
    var body: some View {
        VStack(spacing: DSSpacing.sm) {
            // content
        }
        .padding(DSSpacing.md)
    }
}
```

---

## 🖼️ Image Handling

**ALWAYS use ImageLoaderView for loading images from URLs:**

```swift
// ✅ Correct
ImageLoaderView(urlString: imageUrl)
    .aspectRatio(1, contentMode: .fill)
    .clipShape(Circle())

// ❌ Wrong - Never use AsyncImage unless specifically requested
AsyncImage(url: URL(string: imageUrl))  // Don't do this
```

---

## 📋 Preview Best Practices

**ALWAYS create multiple previews showing different states:**

```swift
#Preview("Full Data") {
    MyComponentView(
        title: "Sample Title",
        subtitle: "Sample Subtitle",
        isLoading: false
    )
}

#Preview("Loading") {
    MyComponentView(
        title: nil,
        subtitle: nil,
        isLoading: true
    )
}

#Preview("Partial Data") {
    MyComponentView(
        title: "Title Only",
        subtitle: nil,
        isLoading: false
    )
}

#Preview("No Data") {
    MyComponentView(
        title: nil,
        subtitle: nil,
        isLoading: false
    )
}
```

---

## 🔄 Data Flow Summary

**The VIPER data flow is STRICT:**

```
View → Presenter → Interactor → Manager
View ← Presenter ← Interactor ← Manager
```

**Rules:**
1. **View** displays data from **Presenter** and calls **Presenter** methods
2. **Presenter** calls **Interactor** for data and **Router** for navigation
3. **Interactor** accesses **Managers** via DependencyContainer
4. **Router** only handles navigation, nothing else
5. **Components** are dumb UI with injected data and callbacks

**NEVER skip layers:**
- ❌ View → Manager (NO!)
- ❌ View → Interactor (NO!)
- ❌ Presenter → Manager (NO!)
- ✅ View → Presenter → Interactor → Manager (YES!)
