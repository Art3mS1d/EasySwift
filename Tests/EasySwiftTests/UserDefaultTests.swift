//
//  UserDefaultTests.swift
//  EasySwiftTests
//
//  Created by Artem Sydorenko on 14.04.2020.
//

import XCTest
@testable import EasySwift


class UserDefaultTests: XCTestCase {
    
    @UserDefault("test1")
    var default1 = "morning"
    
    func testSimple() {
        default1 = "night"
        XCTAssertEqual(default1, "night")
    }
    
    @UserDefault(wrappedValue: nil, "test2")
    var default2: Date?
    
    func testOptional() {
        XCTAssertNil(default2)
        default2 = Date()
        XCTAssertNotNil(default2)
        default2 = nil
        XCTAssertNil(default2)
    }
    

    @UserDefault(.firstLaunchDate)
    var firstLaunch = nil


}

extension UserDefault.Key {
    static var firstLaunchDate: UserDefault.Key<Date?> { #function }
}
