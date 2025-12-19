# Testing Guide

This guide covers testing patterns and best practices for the CleanTemplate project.

---

## Presenter Unit Testing

### Overview

Presenters contain all business logic and are the primary target for unit testing. The template provides base mock classes to simplify testing.

### Test File Location

- Test helpers: `CleanTemplateUnitTests/TestHelpers/PresenterTestHelpers.swift`
- Presenter tests: `CleanTemplateUnitTests/PresenterTests/`

### Creating Screen-Specific Mocks

Every screen needs its own mock Router and Interactor that extend the base mocks:

```swift
import Testing
import SwiftUI
@testable import CleanTemplate

// Screen-specific mock router
@MainActor
class MockHomeRouter: MockGlobalRouter, HomeRouter {

    var showDevSettingsViewCalled = false

    func showDevSettingsView() {
        showDevSettingsViewCalled = true
    }

    override func reset() {
        super.reset()
        showDevSettingsViewCalled = false
    }
}

// Screen-specific mock interactor
@MainActor
class MockHomeInteractor: MockGlobalInteractor, HomeInteractor {
    // Add any screen-specific properties/methods
}
```

### Writing Presenter Tests

Follow the Arrange-Act-Assert pattern:

```swift
@Suite("HomePresenter Tests")
struct HomePresenterTests {

    @MainActor
    @Test("onViewAppear tracks screen event")
    func onViewAppear_tracksScreenEvent() async throws {
        // Arrange
        let mockInteractor = MockHomeInteractor()
        let mockRouter = MockHomeRouter()
        let presenter = HomePresenter(interactor: mockInteractor, router: mockRouter)
        let delegate = HomeDelegate()

        // Act
        presenter.onViewAppear(delegate: delegate)

        // Assert
        #expect(mockInteractor.didTrackScreenEvent("HomeView_Appear"))
        #expect(mockInteractor.trackedScreenEvents.count == 1)
    }
}
```

### MockGlobalInteractor Helpers

The base mock interactor provides these assertion helpers:

```swift
// Check if any event was tracked
mockInteractor.didTrackEvent("EventName") -> Bool

// Check if screen event was tracked
mockInteractor.didTrackScreenEvent("ScreenName_Appear") -> Bool

// Access all tracked events
mockInteractor.trackedEvents: [String]
mockInteractor.trackedScreenEvents: [String]

// Check parameters and types
mockInteractor.allTrackedParameters: [[String: Any]?]
mockInteractor.allTrackedTypes: [LogType]

// Check haptic feedback
mockInteractor.hapticPlayed: HapticOption?
mockInteractor.hapticPlayedCount: Int
```

### MockGlobalRouter Helpers

The base mock router tracks these navigation calls:

```swift
mockRouter.dismissScreenCalled: Bool
mockRouter.dismissEnvironmentCalled: Bool
mockRouter.dismissPushStackCalled: Bool
mockRouter.dismissModalCalled: Bool
mockRouter.dismissAlertCalled: Bool

mockRouter.showAlertCalled: Bool
mockRouter.lastAlertTitle: String?
mockRouter.lastAlertSubtitle: String?
mockRouter.lastAlertStyle: AlertStyle?

mockRouter.showSimpleAlertCalled: Bool
mockRouter.showErrorAlertCalled: Bool
mockRouter.lastError: Error?
```

### What to Test in Presenters

1. **Event Tracking**: Verify correct events are tracked with proper names
2. **Navigation**: Verify router methods are called
3. **State Changes**: Verify presenter state is updated correctly
4. **Conditional Logic**: Test different code paths (e.g., with/without data)
5. **Error Handling**: Verify error events are tracked with .severe type

### Test Naming Convention

Use descriptive names: `methodName_condition_expectedResult`

```swift
@Test func onViewAppear_tracksScreenEvent() { }
@Test func handleDeepLink_withValidQueryItems_tracksSuccess() { }
@Test func handleDeepLink_withoutQueryItems_tracksNoItems() { }
@Test func onSave_whenNetworkFails_showsErrorAlert() { }
```

---

## Accessibility Identifiers for UI Testing

### Overview

Consistent accessibility identifiers enable reliable UI testing. Use the `AccessibilityID` enum and view extensions for standardized identifiers.

### Identifier Format

All identifiers follow the pattern: `ScreenName_ElementType_Name`

Examples:
- `Home_Button_Settings`
- `Profile_Text_Username`
- `Settings_List`
- `Search_Cell_0`

### Using AccessibilityID Helpers

```swift
import SwiftUI

// In Views - use the helper extensions
Text(username)
    .testID("Profile", "Username")

Button("Save") { }
    .buttonTestID("Profile", "Save")

TextField("Email", text: $email)
    .inputTestID("CreateAccount", "Email")

// In Lists
ForEach(items.indices, id: \.self) { index in
    ItemRow(item: items[index])
        .cellTestID("ItemList", index: index)
}
```

### Available Helper Methods

```swift
// Generic identifier
view.testID(_ screen: String, _ element: String)

// Button-specific
view.buttonTestID(_ screen: String, _ name: String)

// Text input-specific
view.inputTestID(_ screen: String, _ name: String)

// List cell with index
view.cellTestID(_ screen: String, index: Int)
```

### Static ID Generators

For use outside view modifiers:

```swift
AccessibilityID.button("Home", "Settings")  // "Home_Button_Settings"
AccessibilityID.text("Profile", "Name")     // "Profile_Text_Name"
AccessibilityID.input("Login", "Password")  // "Login_Input_Password"
AccessibilityID.list("Settings")            // "Settings_List"
AccessibilityID.cell("Items", index: 5)     // "Items_Cell_5"
AccessibilityID.image("Profile", "Avatar")  // "Profile_Image_Avatar"
AccessibilityID.toggle("Settings", "Notifications") // "Settings_Toggle_Notifications"
```

### UI Test Example

```swift
import XCTest

final class HomeUITests: XCTestCase {

    func testSettingsButtonNavigatesToSettings() throws {
        let app = XCUIApplication()
        app.launch()

        // Find element by accessibility identifier
        let settingsButton = app.buttons["Home_Button_Settings"]
        XCTAssertTrue(settingsButton.exists)

        settingsButton.tap()

        // Verify navigation
        let settingsTitle = app.staticTexts["Settings_Text_Title"]
        XCTAssertTrue(settingsTitle.waitForExistence(timeout: 2))
    }
}
```

---

## SwiftUI Preview Testing

### Using PreviewHelpers

The template provides utilities to simplify preview setup.

### PreviewRouter - For Screens

```swift
// Before (verbose)
#Preview {
    let container = DevPreview.shared.container()
    let interactor = CoreInteractor(container: container)
    let builder = CoreBuilder(interactor: interactor)

    return RouterView { router in
        builder.homeView(router: router, delegate: HomeDelegate())
    }
}

// After (simple)
#Preview {
    PreviewRouter { router in
        DevPreview.builder.homeView(router: router, delegate: HomeDelegate())
    }
}
```

### PreviewState - For Binding-Based Views

```swift
#Preview {
    PreviewState(initialValue: "") { text in
        TextField("Name", text: text)
    }
}

#Preview {
    PreviewState(initialValue: false) { isOn in
        Toggle("Enabled", isOn: isOn)
    }
}
```

### PreviewContainer - For Components

```swift
#Preview {
    PreviewContainer {
        MyComponentView(title: "Hello", onTap: { })
    }
}

// With custom background
#Preview {
    PreviewContainer(backgroundColor: .backgroundSecondary) {
        MyComponentView(title: "Hello", onTap: { })
    }
}
```

### DevPreview Extensions

Quick access to dependencies:

```swift
DevPreview.interactor  // Pre-built CoreInteractor
DevPreview.builder     // Pre-built CoreBuilder
```

### Multiple Preview States

Always create previews for different states:

```swift
#Preview("Full Data") {
    ProfileCardView(
        imageUrl: "https://picsum.photos/100",
        title: "John Doe",
        subtitle: "Developer",
        isLoading: false
    )
}

#Preview("Loading") {
    ProfileCardView(
        imageUrl: nil,
        title: nil,
        subtitle: nil,
        isLoading: true
    )
}

#Preview("Partial Data") {
    ProfileCardView(
        imageUrl: nil,
        title: "Jane Smith",
        subtitle: nil,
        isLoading: false
    )
}

#Preview("Dark Mode") {
    ProfileCardView(
        imageUrl: "https://picsum.photos/100",
        title: "John Doe",
        subtitle: "Developer",
        isLoading: false
    )
    .preferredColorScheme(.dark)
}
```

---

## Test Coverage Priorities

### High Priority (Always Test)

1. **Presenter event tracking** - Every user action should be tracked
2. **Navigation logic** - Screen transitions and modal presentations
3. **Error handling** - Error states and user feedback
4. **Core business logic** - Data transformations and validations

### Medium Priority

1. **Edge cases** - Empty data, nil values, boundary conditions
2. **Async operations** - Loading states and completion handlers
3. **User preferences** - Settings that affect behavior

### Low Priority (Visual Testing via Previews)

1. **UI layout** - Use multiple previews instead
2. **Styling** - Verify in previews with different states
3. **Animations** - Manual testing recommended

---

## Running Tests

### Unit Tests

```bash
# Run all unit tests
xcodebuild test -scheme "CleanTemplate - Mock" -destination 'platform=iOS Simulator,name=iPhone 15'

# Run specific test file
xcodebuild test -scheme "CleanTemplate - Mock" -only-testing:CleanTemplateUnitTests/HomePresenterTests
```

### UI Tests

```bash
# Run all UI tests
xcodebuild test -scheme "CleanTemplate - Mock" -destination 'platform=iOS Simulator,name=iPhone 15' -only-testing:CleanTemplateUITests
```

### In Xcode

- `Cmd + U` - Run all tests
- Click diamond next to test method - Run single test
- Product → Test → Select specific tests

---

## Best Practices

### Do

- Test presenter methods, not views
- Use descriptive test names
- Reset mocks between tests if reusing
- Test both success and failure paths
- Use `@MainActor` for all presenter tests
- Create multiple previews for visual testing

### Don't

- Test private implementation details
- Test SwiftUI view body directly
- Skip event tracking assertions
- Use real services in unit tests
- Hardcode accessibility identifiers (use helpers)

---

## Quick Reference

### Creating a New Presenter Test File

1. Create file: `CleanTemplateUnitTests/PresenterTests/[Screen]PresenterTests.swift`
2. Add screen-specific mock router (extend MockGlobalRouter)
3. Add screen-specific mock interactor (extend MockGlobalInteractor)
4. Create test suite with `@Suite`
5. Add tests with `@Test` and `@MainActor`

### Test Template

```swift
import Testing
import SwiftUI
@testable import CleanTemplate

@MainActor
class Mock[Screen]Router: MockGlobalRouter, [Screen]Router {
    // Add screen-specific navigation tracking
}

@MainActor
class Mock[Screen]Interactor: MockGlobalInteractor, [Screen]Interactor {
    // Add screen-specific data
}

@Suite("[Screen]Presenter Tests")
struct [Screen]PresenterTests {

    @MainActor
    @Test("onViewAppear tracks screen event")
    func onViewAppear_tracksScreenEvent() async throws {
        let mockInteractor = Mock[Screen]Interactor()
        let mockRouter = Mock[Screen]Router()
        let presenter = [Screen]Presenter(interactor: mockInteractor, router: mockRouter)

        presenter.onViewAppear(delegate: [Screen]Delegate())

        #expect(mockInteractor.didTrackScreenEvent("[Screen]View_Appear"))
    }
}
```
