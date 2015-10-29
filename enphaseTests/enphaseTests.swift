//
//  enphaseTests.swift
//  enphaseTests
//
//  Created by Adam Kuert on 10/26/15.
//  Copyright © 2015 Adam Kuert. All rights reserved.
//

import XCTest
@testable import enphase

class enphaseTests: XCTestCase {
    var data: SolarData?
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        let path = NSBundle.mainBundle().pathForResource("data", ofType: "json")
        data = SolarData(fromPath: path!)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testSystemID() {
        let jsonResult = data!.asJson()
        let system_id: NSInteger = (jsonResult["system_id"] as? NSInteger)!
        XCTAssertEqual(system_id, 752126)
    }
    
    func testTotal() {
        let total = data!.getTotal()
        XCTAssertEqual(total, 265)
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
}
