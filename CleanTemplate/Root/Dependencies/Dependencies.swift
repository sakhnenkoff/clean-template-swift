//
//  Dependencies.swift
//  CleanTemplate
//
//  Initializes all managers based on BuildConfiguration and FeatureFlags.
//  Optional features are conditionally initialized to reduce memory/startup time.
//
import SwiftUI
import SwiftfulRouting
import LocalPersistance
import LocalPersistanceMock
import Networking

@MainActor
struct Dependencies {
    let container: DependencyContainer

    // swiftlint:disable:next function_body_length cyclomatic_complexity
    init(config: BuildConfiguration) {
        // Required managers (always initialized)
        let authManager: AuthManager
        let userManager: UserManager
        let appState: AppState
        let logManager: LogManager
        let keychainService: KeychainCacheServiceProtocol
        let userDefaultsService: UserDefaultsCacheServiceProtocol
        let networkingService: NetworkingServiceProtocol

        // Optional managers (nil if feature disabled)
        var abTestManager: ABTestManager?
        var purchaseManager: PurchaseManager?
        var pushManager: PushManager?
        var hapticManager: HapticManager?
        var soundEffectManager: SoundEffectManager?
        var streakManager: StreakManager?
        var xpManager: ExperiencePointsManager?
        var progressManager: ProgressManager?

        switch config {
        case .mock(isSignedIn: let isSignedIn):
            // Build logging services
            logManager = LogManager(services: [
                ConsoleService(printParameters: true, system: .stdout)
            ])

            // Required managers
            authManager = AuthManager(service: MockAuthService(user: isSignedIn ? .mock() : nil), logger: logManager)
            userManager = UserManager(services: MockUserServices(document: isSignedIn ? UserModel.mock : nil), configuration: Dependencies.userManagerConfiguration, logger: logManager)
            appState = AppState(startingModuleId: isSignedIn ? Constants.tabbarModuleId : Constants.onboardingModuleId)
            keychainService = MockKeychainCacheService()
            userDefaultsService = MockUserDefaultsCacheService()
            networkingService = NetworkingService()

            // Optional managers - only initialize if feature enabled
            if FeatureFlags.enableABTesting {
                let abTestService = MockABTestService(boolTest: nil, enumTest: nil)
                abTestManager = ABTestManager(service: abTestService, logManager: logManager)
            }
            if FeatureFlags.enablePurchases {
                purchaseManager = PurchaseManager(service: MockPurchaseService(), logger: logManager)
            }
            if FeatureFlags.enableHaptics {
                hapticManager = HapticManager(logger: logManager)
            }
            if FeatureFlags.enableStreaks {
                streakManager = StreakManager(services: MockStreakServices(), configuration: Dependencies.streakConfiguration, logger: logManager)
            }
            if FeatureFlags.enableExperiencePoints {
                xpManager = ExperiencePointsManager(services: MockExperiencePointsServices(), configuration: Dependencies.xpConfiguration, logger: logManager)
            }
            if FeatureFlags.enableProgress {
                progressManager = ProgressManager(services: MockProgressServices(), configuration: Dependencies.progressConfiguration, logger: logManager)
            }

        case .dev:
            // Build logging services based on feature flags
            var loggingServices: [any LogService] = [ConsoleService(printParameters: true)]
            if FeatureFlags.enableFirebaseAnalytics {
                loggingServices.append(FirebaseAnalyticsService())
            }
            if FeatureFlags.enableMixpanel {
                loggingServices.append(MixpanelService(token: Keys.mixpanelToken))
            }
            if FeatureFlags.enableCrashlytics {
                loggingServices.append(FirebaseCrashlyticsService())
            }
            logManager = LogManager(services: loggingServices)

            // Required managers
            authManager = AuthManager(service: FirebaseAuthService(), logger: logManager)
            userManager = UserManager(services: ProductionUserServices(), configuration: Dependencies.userManagerConfiguration, logger: logManager)
            appState = AppState()
            keychainService = KeychainCacheService()
            userDefaultsService = UserDefaultsCacheService()
            networkingService = NetworkingService()

            // Optional managers
            if FeatureFlags.enableABTesting {
                abTestManager = ABTestManager(service: LocalABTestService(), logManager: logManager)
            }
            if FeatureFlags.enablePurchases {
                purchaseManager = PurchaseManager(
                    service: RevenueCatPurchaseService(apiKey: Keys.revenueCatAPIKey),
                    logger: logManager
                )
            }
            if FeatureFlags.enableHaptics {
                hapticManager = HapticManager(logger: logManager)
            }
            if FeatureFlags.enableStreaks {
                streakManager = StreakManager(services: ProdStreakServices(), configuration: Dependencies.streakConfiguration, logger: logManager)
            }
            if FeatureFlags.enableExperiencePoints {
                xpManager = ExperiencePointsManager(services: ProdExperiencePointsServices(), configuration: Dependencies.xpConfiguration, logger: logManager)
            }
            if FeatureFlags.enableProgress {
                progressManager = ProgressManager(services: ProdProgressServices(), configuration: Dependencies.progressConfiguration, logger: logManager)
            }

        case .prod:
            // Build logging services based on feature flags (no console in prod)
            var loggingServices: [any LogService] = []
            if FeatureFlags.enableFirebaseAnalytics {
                loggingServices.append(FirebaseAnalyticsService())
            }
            if FeatureFlags.enableMixpanel {
                loggingServices.append(MixpanelService(token: Keys.mixpanelToken))
            }
            if FeatureFlags.enableCrashlytics {
                loggingServices.append(FirebaseCrashlyticsService())
            }
            logManager = LogManager(services: loggingServices)

            // Required managers
            authManager = AuthManager(service: FirebaseAuthService(), logger: logManager)
            userManager = UserManager(services: ProductionUserServices(), configuration: Dependencies.userManagerConfiguration, logger: logManager)
            appState = AppState()
            keychainService = KeychainCacheService()
            userDefaultsService = UserDefaultsCacheService()
            networkingService = NetworkingService()

            // Optional managers
            if FeatureFlags.enableABTesting {
                abTestManager = ABTestManager(service: FirebaseABTestService(), logManager: logManager)
            }
            if FeatureFlags.enablePurchases {
                purchaseManager = PurchaseManager(
                    service: RevenueCatPurchaseService(apiKey: Keys.revenueCatAPIKey),
                    logger: logManager
                )
            }
            if FeatureFlags.enableHaptics {
                hapticManager = HapticManager(logger: logManager)
            }
            if FeatureFlags.enableStreaks {
                streakManager = StreakManager(services: ProdStreakServices(), configuration: Dependencies.streakConfiguration, logger: logManager)
            }
            if FeatureFlags.enableExperiencePoints {
                xpManager = ExperiencePointsManager(services: ProdExperiencePointsServices(), configuration: Dependencies.xpConfiguration, logger: logManager)
            }
            if FeatureFlags.enableProgress {
                progressManager = ProgressManager(services: ProdProgressServices(), configuration: Dependencies.progressConfiguration, logger: logManager)
            }
        }

        // Common optional managers (shared across all configs)
        if FeatureFlags.enablePushNotifications {
            pushManager = PushManager(logManager: logManager)
        }
        if FeatureFlags.enableSoundEffects {
            soundEffectManager = SoundEffectManager(logger: logManager)
        }

        // Register managers in container
        let container = DependencyContainer()

        // Required managers (always register)
        container.register(AuthManager.self, service: authManager)
        container.register(UserManager.self, service: userManager)
        container.register(LogManager.self, service: logManager)
        container.register(AppState.self, service: appState)
        container.register(KeychainCacheServiceProtocol.self, service: keychainService)
        container.register(UserDefaultsCacheServiceProtocol.self, service: userDefaultsService)
        container.register(NetworkingServiceProtocol.self, service: networkingService)

        // Optional managers (only register if enabled)
        if let abTestManager {
            container.register(ABTestManager.self, service: abTestManager)
        }
        if let purchaseManager {
            container.register(PurchaseManager.self, service: purchaseManager)
        }
        if let pushManager {
            container.register(PushManager.self, service: pushManager)
        }
        if let hapticManager {
            container.register(HapticManager.self, service: hapticManager)
        }
        if let soundEffectManager {
            container.register(SoundEffectManager.self, service: soundEffectManager)
        }
        if let streakManager {
            container.register(StreakManager.self, key: Dependencies.streakConfiguration.streakKey, service: streakManager)
        }
        if let xpManager {
            container.register(ExperiencePointsManager.self, key: Dependencies.xpConfiguration.experienceKey, service: xpManager)
        }
        if let progressManager {
            container.register(ProgressManager.self, key: Dependencies.progressConfiguration.progressKey, service: progressManager)
        }

        self.container = container

        SwiftfulRoutingLogger.enableLogging(logger: logManager)
    }

    static let streakConfiguration = StreakConfiguration(
        streakKey: Constants.streakKey,
        eventsRequiredPerDay: 1,
        useServerCalculation: false,
        leewayHours: 0,
        freezeBehavior: .autoConsumeFreezes
    )

    static let xpConfiguration = ExperiencePointsConfiguration(
        experienceKey: Constants.xpKey,
        useServerCalculation: false
    )

    static let progressConfiguration = ProgressConfiguration(
        progressKey: Constants.progressKey
    )

    static let userManagerConfiguration = DataManagerSyncConfiguration(
        managerKey: "UserMan",
        enablePendingWrites: true
    )

}

@MainActor
class DevPreview {
    static let shared = DevPreview()

    func container() -> DependencyContainer {
        let container = DependencyContainer()

        // Required managers (always register)
        container.register(AuthManager.self, service: authManager)
        container.register(UserManager.self, service: userManager)
        container.register(LogManager.self, service: logManager)
        container.register(AppState.self, service: appState)
        container.register(KeychainCacheServiceProtocol.self, service: keychainService)
        container.register(UserDefaultsCacheServiceProtocol.self, service: userDefaultsService)
        container.register(NetworkingServiceProtocol.self, service: networkingService)

        // Optional managers (only register if enabled)
        if let abTestManager {
            container.register(ABTestManager.self, service: abTestManager)
        }
        if let purchaseManager {
            container.register(PurchaseManager.self, service: purchaseManager)
        }
        if let pushManager {
            container.register(PushManager.self, service: pushManager)
        }
        if let hapticManager {
            container.register(HapticManager.self, service: hapticManager)
        }
        if let soundEffectManager {
            container.register(SoundEffectManager.self, service: soundEffectManager)
        }
        if let streakManager {
            container.register(StreakManager.self, key: Dependencies.streakConfiguration.streakKey, service: streakManager)
        }
        if let xpManager {
            container.register(ExperiencePointsManager.self, key: Dependencies.xpConfiguration.experienceKey, service: xpManager)
        }
        if let progressManager {
            container.register(ProgressManager.self, key: Dependencies.progressConfiguration.progressKey, service: progressManager)
        }

        return container
    }

    // Required managers
    let authManager: AuthManager
    let userManager: UserManager
    let logManager: LogManager
    let appState: AppState
    let keychainService: KeychainCacheServiceProtocol
    let userDefaultsService: UserDefaultsCacheServiceProtocol
    let networkingService: NetworkingServiceProtocol

    // Optional managers
    var abTestManager: ABTestManager?
    var purchaseManager: PurchaseManager?
    var pushManager: PushManager?
    var hapticManager: HapticManager?
    var soundEffectManager: SoundEffectManager?
    var streakManager: StreakManager?
    var xpManager: ExperiencePointsManager?
    var progressManager: ProgressManager?

    init(isSignedIn: Bool = true) {
        // Required managers
        self.authManager = AuthManager(service: MockAuthService(user: isSignedIn ? .mock() : nil))
        self.userManager = UserManager(services: MockUserServices(document: isSignedIn ? .mock : nil), configuration: DataManagerSyncConfiguration.mockNoPendingWrites())
        self.logManager = LogManager(services: [])
        self.appState = AppState()
        self.keychainService = MockKeychainCacheService()
        self.userDefaultsService = MockUserDefaultsCacheService()
        self.networkingService = NetworkingService()

        // Optional managers - only initialize if feature enabled
        if FeatureFlags.enableABTesting {
            self.abTestManager = ABTestManager(service: MockABTestService())
        }
        if FeatureFlags.enablePurchases {
            self.purchaseManager = PurchaseManager(service: MockPurchaseService())
        }
        if FeatureFlags.enablePushNotifications {
            self.pushManager = PushManager()
        }
        if FeatureFlags.enableHaptics {
            self.hapticManager = HapticManager()
        }
        if FeatureFlags.enableSoundEffects {
            self.soundEffectManager = SoundEffectManager()
        }
        if FeatureFlags.enableStreaks {
            self.streakManager = StreakManager(services: MockStreakServices(), configuration: StreakConfiguration.mockDefault())
        }
        if FeatureFlags.enableExperiencePoints {
            self.xpManager = ExperiencePointsManager(services: MockExperiencePointsServices(), configuration: ExperiencePointsConfiguration.mockDefault())
        }
        if FeatureFlags.enableProgress {
            self.progressManager = ProgressManager(services: MockProgressServices(), configuration: ProgressConfiguration.mockDefault())
        }
    }
}
