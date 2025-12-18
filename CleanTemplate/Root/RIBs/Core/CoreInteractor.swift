import SwiftUI
import LocalPersistance
import Networking

@MainActor
struct CoreInteractor: GlobalInteractor {
    // Required managers (always available)
    private let appState: AppState
    private let authManager: AuthManager
    private let userManager: UserManager
    private let logManager: LogManager
    private let keychainService: KeychainCacheServiceProtocol
    private let userDefaultsService: UserDefaultsCacheServiceProtocol
    private let networkingService: NetworkingServiceProtocol

    // Optional managers (nil if feature disabled via FeatureFlags)
    private let abTestManager: ABTestManager?
    private let purchaseManager: PurchaseManager?
    private let pushManager: PushManager?
    private let hapticManager: HapticManager?
    private let soundEffectManager: SoundEffectManager?
    private let streakManager: StreakManager?
    private let xpManager: ExperiencePointsManager?
    private let progressManager: ProgressManager?

    init(container: DependencyContainer) {
        // Required managers (force unwrap - must exist)
        self.appState = container.resolve(AppState.self)!
        self.authManager = container.resolve(AuthManager.self)!
        self.userManager = container.resolve(UserManager.self)!
        self.logManager = container.resolve(LogManager.self)!
        self.keychainService = container.resolve(KeychainCacheServiceProtocol.self)!
        self.userDefaultsService = container.resolve(UserDefaultsCacheServiceProtocol.self)!
        self.networkingService = container.resolve(NetworkingServiceProtocol.self)!

        // Optional managers (nil if not registered)
        self.abTestManager = container.resolve(ABTestManager.self)
        self.purchaseManager = container.resolve(PurchaseManager.self)
        self.pushManager = container.resolve(PushManager.self)
        self.hapticManager = container.resolve(HapticManager.self)
        self.soundEffectManager = container.resolve(SoundEffectManager.self)
        self.streakManager = container.resolve(StreakManager.self, key: Dependencies.streakConfiguration.streakKey)
        self.xpManager = container.resolve(ExperiencePointsManager.self, key: Dependencies.xpConfiguration.experienceKey)
        self.progressManager = container.resolve(ProgressManager.self, key: Dependencies.progressConfiguration.progressKey)
    }

    // MARK: APP STATE

    var startingModuleId: String {
        appState.startingModuleId
    }

    // MARK: AuthManager

    var auth: UserAuthInfo? {
        authManager.auth
    }

    func getAuthId() throws -> String {
        try authManager.getAuthId()
    }

    func signInAnonymously() async throws -> (user: UserAuthInfo, isNewUser: Bool) {
        try await authManager.signInAnonymously()
    }

    func signInApple() async throws -> (user: UserAuthInfo, isNewUser: Bool) {
        try await authManager.signInApple()
    }

    func signInGoogle() async throws -> (user: UserAuthInfo, isNewUser: Bool) {
        guard let clientId = Constants.firebaseAppClientId else {
            throw AppError("Firebase not configured or clientID missing")
        }
        return try await authManager.signInGoogle(GIDClientID: clientId)
    }

    // MARK: UserManager

    var currentUser: UserModel? {
        userManager.currentUser
    }

    func getCurrentUser() async throws -> UserModel {
        try await userManager.getUser()
    }

    func saveOnboardingComplete() async throws {
        try await userManager.saveOnboardingCompleteForCurrentUser()
    }

    func saveUserName(name: String) async throws {
        try await userManager.saveUserName(name: name)
    }

    func saveUserEmail(email: String) async throws {
        try await userManager.saveUserEmail(email: email)
    }

    func saveUserProfileImage(image: UIImage) async throws {
        try await userManager.saveUserProfileImage(image: image)
    }

    func saveUserFCMToken(token: String) async throws {
        try await userManager.saveUserFCMToken(token: token)
    }

    // MARK: LogManager

    func identifyUser(userId: String, name: String?, email: String?) {
        logManager.identifyUser(userId: userId, name: name, email: email)
    }

    func addUserProperties(dict: [String: Any], isHighPriority: Bool) {
        logManager.addUserProperties(dict: dict, isHighPriority: isHighPriority)
    }

    func deleteUserProfile() {
        logManager.deleteUserProfile()
    }

    func trackEvent(eventName: String, parameters: [String: Any]? = nil, type: LogType = .analytic) {
        logManager.trackEvent(eventName: eventName, parameters: parameters, type: type)
    }

    func trackEvent(event: AnyLoggableEvent) {
        logManager.trackEvent(event: event)
    }

    func trackEvent(event: LoggableEvent) {
        logManager.trackEvent(event: event)
    }

    func trackScreenEvent(event: LoggableEvent) {
        logManager.trackEvent(event: event)
    }

    // MARK: PushManager (Optional)

    func requestPushAuthorization() async throws -> Bool {
        guard let pushManager else {
            print("⚠️ PushManager not enabled. Set FeatureFlags.enablePushNotifications = true")
            return false
        }
        return try await pushManager.requestAuthorization()
    }

    func canRequestPushAuthorization() async -> Bool {
        guard let pushManager else { return false }
        return await pushManager.canRequestAuthorization()
    }

    // MARK: ABTestManager (Optional)

    var activeTests: ActiveABTests? {
        abTestManager?.activeTests
    }

    func override(updateTests: ActiveABTests) throws {
        guard let abTestManager else {
            print("⚠️ ABTestManager not enabled. Set FeatureFlags.enableABTesting = true")
            return
        }
        try abTestManager.override(updateTests: updateTests)
    }

    // MARK: PurchaseManager (Optional)

    var entitlements: [PurchasedEntitlement] {
        purchaseManager?.entitlements ?? []
    }

    var isPremium: Bool {
        entitlements.hasActiveEntitlement
    }

    func getProducts(productIds: [String]) async throws -> [AnyProduct] {
        guard let purchaseManager else {
            print("⚠️ PurchaseManager not enabled. Set FeatureFlags.enablePurchases = true")
            return []
        }
        return try await purchaseManager.getProducts(productIds: productIds)
    }

    func restorePurchase() async throws -> [PurchasedEntitlement] {
        guard let purchaseManager else {
            print("⚠️ PurchaseManager not enabled. Set FeatureFlags.enablePurchases = true")
            return []
        }
        return try await purchaseManager.restorePurchase()
    }

    func purchaseProduct(productId: String) async throws -> [PurchasedEntitlement] {
        guard let purchaseManager else {
            print("⚠️ PurchaseManager not enabled. Set FeatureFlags.enablePurchases = true")
            return []
        }
        return try await purchaseManager.purchaseProduct(productId: productId)
    }

    func updateProfileAttributes(attributes: PurchaseProfileAttributes) async throws {
        guard let purchaseManager else { return }
        try await purchaseManager.updateProfileAttributes(attributes: attributes)
    }

    // MARK: Haptics (Optional)

    func prepareHaptic(option: HapticOption) {
        hapticManager?.prepare(option: option)
    }

    func prepareHaptics(options: [HapticOption]) {
        hapticManager?.prepare(options: options)
    }

    func playHaptic(option: HapticOption) {
        hapticManager?.play(option: option)
    }

    func playHaptics(options: [HapticOption]) {
        hapticManager?.play(options: options)
    }

    func tearDownHaptic(option: HapticOption) {
        hapticManager?.tearDown(option: option)
    }

    func tearDownHaptics(options: [HapticOption]) {
        hapticManager?.tearDown(options: options)
    }

    func tearDownAllHaptics() {
        hapticManager?.tearDownAll()
    }

    // MARK: Sound Effects (Optional)

    func prepareSoundEffect(sound: SoundEffectFile, simultaneousPlayers: Int = 1) {
        guard let url = sound.url, let soundEffectManager else { return }
        Task {
            await soundEffectManager.prepare(url: url, simultaneousPlayers: simultaneousPlayers, volume: 1)
        }
    }

    func tearDownSoundEffect(sound: SoundEffectFile) {
        guard let url = sound.url, let soundEffectManager else { return }
        Task {
            await soundEffectManager.tearDown(url: url)
        }
    }

    func playSoundEffect(sound: SoundEffectFile) {
        guard let url = sound.url, let soundEffectManager else { return }
        Task {
            await soundEffectManager.play(url: url)
        }
    }

    // MARK: StreakManager (Optional)

    var currentStreakData: CurrentStreakData? {
        streakManager?.currentStreakData
    }

    @discardableResult
    func addStreakEvent(metadata: [String: GamificationDictionaryValue] = [:]) async throws -> StreakEvent? {
        guard let streakManager else {
            print("⚠️ StreakManager not enabled. Set FeatureFlags.enableStreaks = true")
            return nil
        }
        return try await streakManager.addStreakEvent(metadata: metadata)
    }

    func getAllStreakEvents() async throws -> [StreakEvent] {
        guard let streakManager else { return [] }
        return try await streakManager.getAllStreakEvents()
    }

    func deleteAllStreakEvents() async throws {
        guard let streakManager else { return }
        try await streakManager.deleteAllStreakEvents()
    }

    @discardableResult
    func addStreakFreeze(id: String, dateExpires: Date? = nil) async throws -> StreakFreeze? {
        guard let streakManager else { return nil }
        return try await streakManager.addStreakFreeze(id: id, dateExpires: dateExpires)
    }

    func useStreakFreezes() async throws {
        guard let streakManager else { return }
        try await streakManager.useStreakFreezes()
    }

    func getAllStreakFreezes() async throws -> [StreakFreeze] {
        guard let streakManager else { return [] }
        return try await streakManager.getAllStreakFreezes()
    }

    func recalculateStreak() {
        streakManager?.recalculateStreak()
    }

    // MARK: ExperiencePointsManager (Optional)

    var currentExperiencePointsData: CurrentExperiencePointsData? {
        xpManager?.currentExperiencePointsData
    }

    @discardableResult
    func addExperiencePoints(points: Int, metadata: [String: GamificationDictionaryValue] = [:]) async throws -> ExperiencePointsEvent? {
        guard let xpManager else {
            print("⚠️ ExperiencePointsManager not enabled. Set FeatureFlags.enableExperiencePoints = true")
            return nil
        }
        return try await xpManager.addExperiencePoints(points: points, metadata: metadata)
    }

    func getAllExperiencePointsEvents() async throws -> [ExperiencePointsEvent] {
        guard let xpManager else { return [] }
        return try await xpManager.getAllExperiencePointsEvents()
    }

    func getAllExperiencePointsEvents(forField field: String, equalTo value: GamificationDictionaryValue) async throws -> [ExperiencePointsEvent] {
        guard let xpManager else { return [] }
        return try await xpManager.getAllExperiencePointsEvents(forField: field, equalTo: value)
    }

    func deleteAllExperiencePointsEvents() async throws {
        guard let xpManager else { return }
        try await xpManager.deleteAllExperiencePointsEvents()
    }

    func recalculateExperiencePoints() {
        xpManager?.recalculateExperiencePoints()
    }

    // MARK: ProgressManager (Optional)

    func getProgress(id: String) -> Double {
        progressManager?.getProgress(id: id) ?? 0
    }

    func getProgressItem(id: String) -> ProgressItem? {
        progressManager?.getProgressItem(id: id)
    }

    func getAllProgress() -> [String: Double] {
        progressManager?.getAllProgress() ?? [:]
    }

    func getAllProgressItems() -> [ProgressItem] {
        progressManager?.getAllProgressItems() ?? []
    }

    func getProgressItems(forMetadataField metadataField: String, equalTo value: GamificationDictionaryValue) -> [ProgressItem] {
        progressManager?.getProgressItems(forMetadataField: metadataField, equalTo: value) ?? []
    }

    func getMaxProgress(forMetadataField metadataField: String, equalTo value: GamificationDictionaryValue) -> Double {
        progressManager?.getMaxProgress(forMetadataField: metadataField, equalTo: value) ?? 0
    }

    @discardableResult
    func addProgress(id: String, value: Double, metadata: [String: GamificationDictionaryValue]? = nil) async throws -> ProgressItem? {
        guard let progressManager else {
            print("⚠️ ProgressManager not enabled. Set FeatureFlags.enableProgress = true")
            return nil
        }
        return try await progressManager.addProgress(id: id, value: value, metadata: metadata)
    }

    func deleteProgress(id: String) async throws {
        guard let progressManager else { return }
        try await progressManager.deleteProgress(id: id)
    }

    func deleteAllProgress() async throws {
        guard let progressManager else { return }
        try await progressManager.deleteAllProgress()
    }

    // MARK: KeychainService

    @discardableResult
    func saveToKeychain(_ string: String, for key: String) -> Bool {
        keychainService.save(string, for: key)
    }

    @discardableResult
    func saveToKeychain(_ data: Data, for key: String) -> Bool {
        keychainService.save(data, for: key)
    }

    @discardableResult
    func saveToKeychain<T: Encodable>(_ object: T, for key: String) throws -> Bool {
        try keychainService.save(object, for: key)
    }

    func fetchStringFromKeychain(for key: String) -> String? {
        keychainService.fetchString(for: key)
    }

    func fetchDataFromKeychain(for key: String) -> Data? {
        keychainService.fetchData(for: key)
    }

    func fetchFromKeychain<T: Decodable>(for key: String) throws -> T? {
        try keychainService.fetch(for: key)
    }

    @discardableResult
    func removeFromKeychain(for key: String) -> Bool {
        keychainService.remove(for: key)
    }

    @discardableResult
    func removeAllFromKeychain() -> Bool {
        keychainService.removeAll()
    }

    // MARK: UserDefaultsService

    func saveToUserDefaults<T: Encodable>(_ object: T, for key: String) throws {
        try userDefaultsService.save(object, for: key)
    }

    func fetchFromUserDefaults<T: Decodable>(for key: String) throws -> T? {
        try userDefaultsService.fetch(for: key)
    }

    func removeFromUserDefaults(for key: String) {
        userDefaultsService.remove(for: key)
    }

    func removeAllFromUserDefaults(forDomain domain: String) {
        userDefaultsService.removeAll(forDomain: domain)
    }

    // MARK: NetworkingService

    func sendRequest<T: Decodable & Sendable>(_ request: URLRequest) async throws -> T {
        try await networkingService.send(request)
    }

    func sendRequest(_ request: URLRequest) async throws {
        try await networkingService.send(request)
    }

    // MARK: SHARED - Login/Logout

    func logIn(user: UserAuthInfo, isNewUser: Bool) async throws {
        // Required login
        try await userManager.signIn(auth: user, isNewUser: isNewUser)

        // Optional logins - run in parallel if available
        await withTaskGroup(of: Void.self) { group in
            if let purchaseManager {
                group.addTask {
                    _ = try? await purchaseManager.logIn(
                        userId: user.uid,
                        userAttributes: PurchaseProfileAttributes(
                            email: user.email,
                            mixpanelDistinctId: Constants.mixpanelDistinctId,
                            firebaseAppInstanceId: Constants.firebaseAnalyticsAppInstanceID
                        )
                    )
                }
            }
            if let streakManager {
                group.addTask {
                    try? await streakManager.logIn(userId: user.uid)
                }
            }
            if let xpManager {
                group.addTask {
                    try? await xpManager.logIn(userId: user.uid)
                }
            }
            if let progressManager {
                group.addTask {
                    try? await progressManager.logIn(userId: user.uid)
                }
            }
        }

        // Add user properties
        logManager.addUserProperties(dict: Utilities.eventParameters, isHighPriority: false)
    }

    func signOut() async throws {
        try authManager.signOut()

        // Required signout
        userManager.signOut()

        // Optional signouts
        if let purchaseManager {
            try await purchaseManager.logOut()
        }
        streakManager?.logOut()
        xpManager?.logOut()
        if let progressManager {
            await progressManager.logOut()
        }
    }

    func deleteAccount() async throws {
        guard let auth else {
            throw AppError("Auth not found.")
        }

        var option: SignInOption = .anonymous
        if auth.authProviders.contains(.apple) {
            option = .apple
        } else if auth.authProviders.contains(.google), let clientId = Constants.firebaseAppClientId {
            option = .google(GIDClientID: clientId)
        }

        // Delete auth
        try await authManager.deleteAccountWithReauthentication(option: option, revokeToken: false) {
            // Delete User profile (Firestore)
            try await userManager.deleteCurrentUser()
        }

        // Delete Purchases (RevenueCat) - optional
        if let purchaseManager {
            try await purchaseManager.logOut()
        }

        // Delete logs (Mixpanel)
        logManager.deleteUserProfile()
    }

}
