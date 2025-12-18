//
//  ShowcaseInteractor.swift
//  CleanTemplate
//
//

import SwiftUI

@MainActor
protocol ShowcaseInteractor: GlobalInteractor {
    // Auth
    var auth: UserAuthInfo? { get }
    var currentUser: UserModel? { get }

    // Gamification
    var currentStreakData: CurrentStreakData? { get }
    var currentExperiencePointsData: CurrentExperiencePointsData? { get }
    func getAllProgressItems() -> [ProgressItem]
    @discardableResult
    func addStreakEvent(metadata: [String: GamificationDictionaryValue]) async throws -> StreakEvent?
    @discardableResult
    func addExperiencePoints(points: Int, metadata: [String: GamificationDictionaryValue]) async throws -> ExperiencePointsEvent?

    // Purchases
    var isPremium: Bool { get }
    var entitlements: [PurchasedEntitlement] { get }

    // Sound Effects
    func playSoundEffect(sound: SoundEffectFile)

    // Push
    func requestPushAuthorization() async throws -> Bool

    // Keychain
    @discardableResult
    func saveToKeychain(_ string: String, for key: String) -> Bool
    func fetchStringFromKeychain(for key: String) -> String?
    @discardableResult
    func removeFromKeychain(for key: String) -> Bool

    // UserDefaults
    func saveToUserDefaults<T: Encodable>(_ object: T, for key: String) throws
    func fetchFromUserDefaults<T: Decodable>(for key: String) throws -> T?
    func removeFromUserDefaults(for key: String)
}

extension CoreInteractor: ShowcaseInteractor { }
