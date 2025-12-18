import Foundation
import LocalPersistance

public final class MockUserDefaultsCacheService: UserDefaultsCacheServiceProtocol, @unchecked Sendable {
    private var storage: [String: Data] = [:]

    public init() {}

    public func save<T: Encodable>(_ object: T, for key: String) throws {
        let data = try JSONEncoder().encode(object)
        storage[key] = data
    }

    public func fetch<T: Decodable>(for key: String) throws -> T? {
        guard let data = storage[key] else { return nil }
        return try JSONDecoder().decode(T.self, from: data)
    }

    public func remove(for key: String) {
        storage.removeValue(forKey: key)
    }

    public func removeAll(forDomain domain: String) {
        storage.removeAll()
    }
}
