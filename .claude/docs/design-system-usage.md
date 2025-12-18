# DesignSystem Package Usage

The DesignSystem package provides reusable UI components, colors, and typography for consistent app design.

---

## ToastView - Notification System

### Basic Usage

```swift
import DesignSystem

struct MyView: View {
    @State private var toast: Toast?

    var body: some View {
        VStack {
            Button("Show Error") {
                toast = .error("Something went wrong!")
            }

            Button("Show Success") {
                toast = .success("Operation completed!")
            }
        }
        .toast($toast)  // Add toast modifier
    }
}
```

### Toast Types

```swift
Toast.error("Error message")      // Red background
Toast.success("Success message")  // Green background
Toast.warning("Warning message")  // Orange background
Toast.info("Info message")        // Blue background
```

### Custom Duration

```swift
Toast.error("Message", duration: 5.0)  // Shows for 5 seconds (default: 3.0)
```

### Manual Toast Creation

```swift
let toast = Toast(
    style: .success,
    message: "Custom toast message",
    duration: 4.0
)
```

---

## LoadingView - Loading Indicators

### Basic Usage with Modifier

```swift
import DesignSystem

struct MyView: View {
    @State private var isLoading = false

    var body: some View {
        ContentView()
            .loading(isLoading, message: "Loading data...")
    }
}
```

### Loading Styles

```swift
// Default style - standard with background
LoadingView(style: .default)

// Overlay style - dark overlay, larger spinner
LoadingView(message: "Please wait...", style: .overlay)

// Inline style - small, no background
LoadingView(style: .inline)
```

### Inline Loading Example

```swift
HStack {
    Text("Processing")
    LoadingView(style: .inline)
}
```

### Style Properties

| Style | Scale | Background | Tint Color |
|-------|-------|------------|------------|
| `.default` | 1.5x | Secondary background | Primary |
| `.overlay` | 2.0x | Black 70% opacity | White |
| `.inline` | 1.0x | Clear | Primary |

---

## Color Extensions

### Semantic Colors

```swift
Color.success   // Green - for success states
Color.warning   // Orange - for warnings
Color.error     // Red - for errors
Color.info      // Blue - for information
```

### Background Colors

```swift
Color.backgroundPrimary    // System background
Color.backgroundSecondary  // Secondary system background
Color.backgroundTertiary   // Tertiary system background
```

### Text Colors

```swift
Color.textPrimary    // Primary label color
Color.textSecondary  // Secondary label color
Color.textTertiary   // Tertiary label color
```

### Hex Color Initializer

```swift
Color(hex: "#FF5733")   // From hex string with #
Color(hex: "FF5733")    // Also works without #
Color(hex: "F53")       // 3-character shorthand
Color(hex: "80FF5733")  // With alpha (ARGB format)
```

---

## Typography (Font Extensions)

### Title Fonts

```swift
Text("Large Title").font(.titleLarge())    // 34pt bold
Text("Medium Title").font(.titleMedium())  // 28pt bold
Text("Small Title").font(.titleSmall())    // 22pt bold
```

### Headline Fonts

```swift
Text("Large Headline").font(.headlineLarge())   // 20pt semibold
Text("Medium Headline").font(.headlineMedium()) // 17pt semibold
Text("Small Headline").font(.headlineSmall())   // 15pt semibold
```

### Body Fonts

```swift
Text("Large Body").font(.bodyLarge())   // 17pt regular
Text("Medium Body").font(.bodyMedium()) // 15pt regular
Text("Small Body").font(.bodySmall())   // 13pt regular
```

### Caption Fonts

```swift
Text("Large Caption").font(.captionLarge())  // 12pt regular
Text("Small Caption").font(.captionSmall())  // 11pt regular
```

### Button Fonts

```swift
Text("Large Button").font(.buttonLarge())   // 17pt semibold
Text("Medium Button").font(.buttonMedium()) // 15pt semibold
Text("Small Button").font(.buttonSmall())   // 13pt semibold
```

---

## Integration with VIPER Pattern

### Toast State in Presenter

Toast state should be managed in the **Presenter**:

```swift
@Observable
@MainActor
class MyScreenPresenter {
    var toast: Toast?

    func onActionCompleted() {
        toast = .success("Action completed!")
    }

    func onError(_ error: Error) {
        toast = .error(error.localizedDescription)
    }
}
```

### View Usage with Presenter

```swift
struct MyScreenView: View {
    @State var presenter: MyScreenPresenter

    var body: some View {
        ContentView()
            .toast($presenter.toast)
    }
}
```

### Loading State in Presenter

```swift
@Observable
@MainActor
class MyScreenPresenter {
    var isLoading = false

    func onLoadData() {
        isLoading = true
        Task {
            defer { isLoading = false }
            try await interactor.fetchData()
        }
    }
}
```

### View with Loading

```swift
struct MyScreenView: View {
    @State var presenter: MyScreenPresenter

    var body: some View {
        ContentView()
            .loading(presenter.isLoading, message: "Loading...")
    }
}
```

---

## Complete Example

```swift
import SwiftUI
import DesignSystem

struct ExampleView: View {
    @State var presenter: ExamplePresenter

    var body: some View {
        VStack(spacing: 20) {
            Text("Welcome")
                .font(.titleLarge())
                .foregroundColor(.textPrimary)

            Text("This is a demo of DesignSystem")
                .font(.bodyMedium())
                .foregroundColor(.textSecondary)

            Button("Load Data") {
                presenter.onLoadData()
            }
            .font(.buttonLarge())

            Button("Show Success") {
                presenter.showSuccess()
            }
            .foregroundColor(.success)

            Button("Show Error") {
                presenter.showError()
            }
            .foregroundColor(.error)
        }
        .padding()
        .background(Color.backgroundPrimary)
        .toast($presenter.toast)
        .loading(presenter.isLoading)
    }
}

@Observable
@MainActor
class ExamplePresenter {
    var toast: Toast?
    var isLoading = false

    func onLoadData() {
        isLoading = true
        Task {
            try? await Task.sleep(for: .seconds(2))
            isLoading = false
            toast = .success("Data loaded!")
        }
    }

    func showSuccess() {
        toast = .success("Operation successful!")
    }

    func showError() {
        toast = .error("Something went wrong!")
    }
}
```

---

## Best Practices

1. **Toast messages should be brief** - Keep messages under 50 characters
2. **Use appropriate toast types** - Match the type to the message meaning
3. **Loading should block interaction** - The overlay style prevents user interaction
4. **Use semantic colors** - Don't hardcode colors, use the semantic extensions
5. **Typography consistency** - Use the font extensions for consistent sizing
6. **State in Presenter** - Keep toast and loading state in the Presenter, not the View
