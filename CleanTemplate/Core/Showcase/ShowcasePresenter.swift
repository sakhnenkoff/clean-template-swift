//
//  ShowcasePresenter.swift
//  CleanTemplate
//
//

import SwiftUI
import DesignSystem

@Observable
@MainActor
class ShowcasePresenter {

    private let interactor: ShowcaseInteractor
    private let router: ShowcaseRouter

    // MARK: UI State

    var toast: Toast?
    var isLoading: Bool = false

    // MARK: Storage Demo State

    var keychainTestValue: String?
    var userDefaultsTestValue: String?

    // MARK: Computed Properties

    var auth: UserAuthInfo? {
        interactor.auth
    }

    var currentUser: UserModel? {
        interactor.currentUser
    }

    var isSignedIn: Bool {
        auth != nil
    }

    var currentStreakData: CurrentStreakData {
        interactor.currentStreakData
    }

    var currentXPData: CurrentExperiencePointsData {
        interactor.currentExperiencePointsData
    }

    var allProgressItems: [ProgressItem] {
        interactor.getAllProgressItems()
    }

    var isPremium: Bool {
        interactor.isPremium
    }

    var entitlements: [PurchasedEntitlement] {
        interactor.entitlements
    }

    // MARK: Init

    init(interactor: ShowcaseInteractor, router: ShowcaseRouter) {
        self.interactor = interactor
        self.router = router
    }

    // MARK: Lifecycle

    func onViewAppear(delegate: ShowcaseDelegate) {
        interactor.trackScreenEvent(event: Event.onAppear(delegate: delegate))
    }

    func onViewDisappear(delegate: ShowcaseDelegate) {
        interactor.trackEvent(event: Event.onDisappear(delegate: delegate))
    }

    func onTabChanged(to tab: ShowcaseTab) {
        interactor.trackEvent(event: Event.tabChanged(tab: tab.rawValue))
    }

    // MARK: Toast Actions

    func showSuccessToast() {
        interactor.trackEvent(event: Event.toastTriggered(style: "success"))
        toast = .success("Operation completed successfully!")
    }

    func showErrorToast() {
        interactor.trackEvent(event: Event.toastTriggered(style: "error"))
        toast = .error("Something went wrong!")
    }

    func showWarningToast() {
        interactor.trackEvent(event: Event.toastTriggered(style: "warning"))
        toast = .warning("Please be careful!")
    }

    func showInfoToast() {
        interactor.trackEvent(event: Event.toastTriggered(style: "info"))
        toast = .info("New features available!")
    }

    func showToast(_ message: String) {
        toast = .info(message)
    }

    // MARK: Loading Actions

    func showLoadingDemo() {
        interactor.trackEvent(event: Event.loadingTriggered)
        isLoading = true
        Task {
            try? await Task.sleep(for: .seconds(2))
            isLoading = false
        }
    }

    // MARK: Haptic Actions

    func triggerHaptic(_ option: HapticOption) {
        interactor.trackEvent(event: Event.hapticTriggered(option: String(describing: option)))
        interactor.playHaptic(option: option)
    }

    // MARK: Sound Actions

    func playSampleSound() {
        interactor.trackEvent(event: Event.soundTriggered)
        interactor.playSoundEffect(sound: .sample)
    }

    // MARK: Gamification Actions

    func addStreakEvent() async {
        interactor.trackEvent(event: Event.streakEventAdded)
        do {
            try await interactor.addStreakEvent(metadata: [:])
            toast = .success("Streak event added!")
        } catch {
            toast = .error(error.localizedDescription)
        }
    }

    func addXPPoints(_ points: Int) async {
        interactor.trackEvent(event: Event.xpAdded(points: points))
        do {
            try await interactor.addExperiencePoints(points: points, metadata: [:])
            toast = .success("+\(points) XP added!")
        } catch {
            toast = .error(error.localizedDescription)
        }
    }

    // MARK: Push Actions

    func requestPushPermission() async {
        interactor.trackEvent(event: Event.pushRequested)
        do {
            let granted = try await interactor.requestPushAuthorization()
            toast = granted ? .success("Push permission granted!") : .warning("Push permission denied")
        } catch {
            toast = .error(error.localizedDescription)
        }
    }

    // MARK: Keychain Actions

    func saveToKeychain(_ value: String) {
        interactor.trackEvent(event: Event.keychainSaved)
        let success = interactor.saveToKeychain(value, for: "showcase_test_key")
        if success {
            toast = .success("Saved to Keychain!")
        } else {
            toast = .error("Failed to save to Keychain")
        }
    }

    func fetchFromKeychain() {
        interactor.trackEvent(event: Event.keychainFetched)
        keychainTestValue = interactor.fetchStringFromKeychain(for: "showcase_test_key")
        if keychainTestValue != nil {
            toast = .info("Value fetched from Keychain")
        } else {
            toast = .warning("No value found in Keychain")
        }
    }

    func deleteFromKeychain() {
        interactor.trackEvent(event: Event.keychainDeleted)
        let success = interactor.removeFromKeychain(for: "showcase_test_key")
        keychainTestValue = nil
        if success {
            toast = .info("Deleted from Keychain")
        }
    }

    // MARK: UserDefaults Actions

    func saveToUserDefaults(_ value: String) {
        interactor.trackEvent(event: Event.userDefaultsSaved)
        do {
            try interactor.saveToUserDefaults(value, for: "showcase_test_key")
            toast = .success("Saved to UserDefaults!")
        } catch {
            toast = .error(error.localizedDescription)
        }
    }

    func fetchFromUserDefaults() {
        interactor.trackEvent(event: Event.userDefaultsFetched)
        do {
            userDefaultsTestValue = try interactor.fetchFromUserDefaults(for: "showcase_test_key")
            if userDefaultsTestValue != nil {
                toast = .info("Value fetched from UserDefaults")
            } else {
                toast = .warning("No value found in UserDefaults")
            }
        } catch {
            toast = .error(error.localizedDescription)
        }
    }

    func deleteFromUserDefaults() {
        interactor.trackEvent(event: Event.userDefaultsDeleted)
        interactor.removeFromUserDefaults(for: "showcase_test_key")
        userDefaultsTestValue = nil
        toast = .info("Deleted from UserDefaults")
    }

    // MARK: Navigation Actions

    func showPushDemo() {
        interactor.trackEvent(event: Event.navigationDemo(type: "push"))
        router.showDemoPushScreen()
    }

    func showSheetDemo() {
        interactor.trackEvent(event: Event.navigationDemo(type: "sheet"))
        router.showDemoSheet()
    }

    func showFullScreenDemo() {
        interactor.trackEvent(event: Event.navigationDemo(type: "fullscreen"))
        router.showDemoFullScreen()
    }

    func showSimpleAlert() {
        interactor.trackEvent(event: Event.navigationDemo(type: "simpleAlert"))
        router.showSimpleAlert(title: "Simple Alert", subtitle: "This is a basic alert with a single dismiss button.")
    }

    func showCustomAlert() {
        interactor.trackEvent(event: Event.navigationDemo(type: "customAlert"))
        router.showCustomButtonsAlert()
    }

    func switchToOnboarding() {
        interactor.trackEvent(event: Event.navigationDemo(type: "moduleSwitch"))
        router.switchToOnboardingModule()
    }
}

// MARK: - Events

extension ShowcasePresenter {

    enum Event: LoggableEvent {
        case onAppear(delegate: ShowcaseDelegate)
        case onDisappear(delegate: ShowcaseDelegate)
        case tabChanged(tab: String)
        case toastTriggered(style: String)
        case loadingTriggered
        case hapticTriggered(option: String)
        case soundTriggered
        case streakEventAdded
        case xpAdded(points: Int)
        case pushRequested
        case keychainSaved
        case keychainFetched
        case keychainDeleted
        case userDefaultsSaved
        case userDefaultsFetched
        case userDefaultsDeleted
        case navigationDemo(type: String)

        var eventName: String {
            switch self {
            case .onAppear:             return "ShowcaseView_Appear"
            case .onDisappear:          return "ShowcaseView_Disappear"
            case .tabChanged:           return "ShowcaseView_TabChanged"
            case .toastTriggered:       return "ShowcaseView_Toast"
            case .loadingTriggered:     return "ShowcaseView_Loading"
            case .hapticTriggered:      return "ShowcaseView_Haptic"
            case .soundTriggered:       return "ShowcaseView_Sound"
            case .streakEventAdded:     return "ShowcaseView_StreakAdded"
            case .xpAdded:              return "ShowcaseView_XPAdded"
            case .pushRequested:        return "ShowcaseView_PushRequest"
            case .keychainSaved:        return "ShowcaseView_Keychain_Save"
            case .keychainFetched:      return "ShowcaseView_Keychain_Fetch"
            case .keychainDeleted:      return "ShowcaseView_Keychain_Delete"
            case .userDefaultsSaved:    return "ShowcaseView_UserDefaults_Save"
            case .userDefaultsFetched:  return "ShowcaseView_UserDefaults_Fetch"
            case .userDefaultsDeleted:  return "ShowcaseView_UserDefaults_Delete"
            case .navigationDemo:       return "ShowcaseView_Navigation"
            }
        }

        var parameters: [String: Any]? {
            switch self {
            case .onAppear(delegate: let delegate), .onDisappear(delegate: let delegate):
                return delegate.eventParameters
            case .tabChanged(tab: let tab):
                return ["tab": tab]
            case .toastTriggered(style: let style):
                return ["style": style]
            case .hapticTriggered(option: let option):
                return ["option": option]
            case .xpAdded(points: let points):
                return ["points": points]
            case .navigationDemo(type: let type):
                return ["type": type]
            default:
                return nil
            }
        }

        var type: LogType {
            .analytic
        }
    }
}
