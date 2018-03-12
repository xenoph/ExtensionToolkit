//
//  ExtensionToolkitTests.swift
//  ExtensionToolkitTests
//
//  Created by Bjørn Vidar Dahle on 12/03/2018.
//  Copyright © 2018 Bjørn Vidar Dahle. All rights reserved.
//

import XCTest
@testable import ExtensionToolkit

class ExtensionToolkitTests: XCTestCase {
    
    func testParseHMS() {
        let testNumber = Int.parseHMS(hms: "01:01:01")
        XCTAssert(testNumber == 3661, "Could not parse String to correct Int")
    }
}
