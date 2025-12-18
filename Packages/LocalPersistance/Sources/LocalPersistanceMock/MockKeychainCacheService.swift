import Foundation
import LocalPersistance

public final class MockKeychainCacheService: KeychainCacheServiceProtocol, @unchecked Sendable {
    private var stringStorage: [String: String] = [:]
    private var dataStorage: [String: Data] = [:]

    public init() {}

    @discardableResult
    public func save(_ string: String, for key: String) -> Bool {
        stringStorage[key] = string
        return true
    }

    @discardableResult
    public func save(_ data: Data, for key: String) -> Bool {
        dataStorage[key] = data
        return true
    }

    @discardableResult
    public func save<T: Encodable>(_ object: T, for key: String) throws -> Bool {
        let data = try JSONEncoder().encode(object)
        dataStorage[key] = data
        return true
    }

    public func fetchString(for key: String) -> String? {
        stringStorage[key]
    }

    public func fetchData(for key: String) -> Data? {
        dataStorage[key]
    }

    public func fetch<T: Decodable>(for key: String) throws -> T? {
        guard let data = dataStorage[key] else { return nil }
        return try JSONDecoder().decode(T.self, from: data)
    }

    @discardableResult
    public func remove(for key: String) -> Bool {
        stringStorage.removeValue(forKey: key)
        dataStorage.removeValue(forKey: key)
        return true
    }

    @discardableResult
    public func removeAll() -> Bool {
        stringStorage.removeAll()
        dataStorage.removeAll()
        return true
    }
}
