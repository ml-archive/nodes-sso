import XCTest
@testable import AdminPanelNodesSSO

class AdminPanelNodesSSOTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        XCTAssertEqual(AdminPanelNodesSSO().text, "Hello, World!")
    }


    static var allTests : [(String, (AdminPanelNodesSSOTests) -> () throws -> Void)] {
        return [
            ("testExample", testExample),
        ]
    }
}
