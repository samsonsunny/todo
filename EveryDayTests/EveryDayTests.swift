//
//  EveryDayTests.swift
//  EveryDayTests
//
//  Created by Sam on 12/19/19.
//  Copyright © 2019 samsonsunny. All rights reserved.
//

import XCTest
@testable import EveryDay

class EveryDayTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

	func testTodayIndex() {
		// given
		let expectedTodayIndex = 352 
		
		// when
		let givenIndex = DateHelper().indexForToday
		print(givenIndex)
		// then
		XCTAssertTrue(expectedTodayIndex == givenIndex)
		
    }
	
	func testTotalDays() {
		
		// given
		let expectedDays = 365 + 366
		
		// when
		let givenIndex = DateHelper().twoYearTotalDays
		print(givenIndex)
		// then
		XCTAssertTrue(expectedDays == givenIndex)
	}
	
	func testToday() {
		
		// given
		let expectedDays = Date().in(region: .local).dateAtStartOf(.day).date
		
		// when
		let givenIndex = DateHelper().dateForSection352
		print(givenIndex)
		// then
		XCTAssertTrue(expectedDays == givenIndex)
	}
	
	func testAllDays() {
		
		print(DateHelper().twoYearsOfDates.count)
		print(DateHelper().twoYearTotalDays)
		XCTAssertTrue(DateHelper().twoYearTotalDays == DateHelper().twoYearsOfDates.count)
	}

    func testPerformanceExample() {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}
