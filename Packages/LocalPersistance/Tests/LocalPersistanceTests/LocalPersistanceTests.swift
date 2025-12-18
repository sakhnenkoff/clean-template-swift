import XCTest
@testable import LocalPersistance
@testable import LocalPersistanceMock

final class LocalPersistanceTests: XCTestCase {
    func testUserDefaultsCacheService_saveAndFetch() throws {
        let service = MockUserDefaultsCacheService()
        let testValue = "Hello, World!"

        try service.save(testValue, for: "testKey")
        let fetched: String? = try service.fetch(for: "testKey")

        XCTAssertEqual(fetched, testValue)
    }

    func testUserDefaultsCacheService_remove() throws {
        let service = MockUserDefaultsCacheService()
        let testValue = "Hello, World!"

        try service.save(testValue, for: "testKey")
        service.remove(for: "testKey")
        let fetched: String? = try service.fetch(for: "testKey")

        XCTAssertNil(fetched)
    }

    func testKeychainCacheService_saveAndFetch() throws {
        let service = MockKeychainCacheService()
        let testValue = "SecretToken"

        service.save(testValue, for: "tokenKey")
        let fetched = service.fetchString(for: "tokenKey")

        XCTAssertEqual(fetched, testValue)
    }

    func testKeychainCacheService_removeAll() throws {
        let service = MockKeychainCacheService()

        service.save("value1", for: "key1")
        service.save("value2", for: "key2")
        service.removeAll()

        XCTAssertNil(service.fetchString(for: "key1"))
        XCTAssertNil(service.fetchString(for: "key2"))
    }
}
