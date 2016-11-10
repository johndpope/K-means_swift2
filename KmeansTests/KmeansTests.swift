//
//  KmeansTests.swift
//  KmeansTests
//
//  Created by 成沢淳史 on 7/12/16.
//  Copyright © 2016 成沢淳史. All rights reserved.
//

import XCTest
@testable import Kmeans

class KmeansTests: XCTestCase {
    var cl : Kmeans?
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        var samples : Array<[Float]> = Array<[Float]>()
        samples.append([1, 3, 2, 1, 7, 8,4, 6])
        samples.append([7,5, 7, 8, 1, 3,3,5])
        samples.append([1, 2, 3,4, 8, 8,9,6])
        samples.append([8, 6, 7, 9, 3, 2,3,1])
        
        
        cl = Kmeans(samples: samples, k: 2, iter: 10)
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        cl!.kmeans()
        cl!.debug()
        
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
}
