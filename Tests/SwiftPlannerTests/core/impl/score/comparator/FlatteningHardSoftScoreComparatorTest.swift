//
/*
 Copied and adapted from OptaPlanner (https://github.com/kiegroup/optaplanner)

 Copyright 2006-2023 kiegroup
 Copyright 2023 KPS Software GmbH

 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at

     http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.

 NOTICE: This file is based on the optaPlanner engine by kiegroup 
         (https://github.com/kiegroup/optaplanner), which is licensed 
         under the Apache License, Version 2.0, too. Furthermore, this
         file has been modified including (but not necessarily
         limited to) translating the original file to Swift.
 */

import XCTest
@testable import SwiftPlanner

class FlatteningHardSoftScoreComparatorTest : XCTestCase {
    
    private var modifier: Int = 0
    private var firstScore: String = ""
    private var secondScore: String = ""
    private var expectedResult: ComparisonResult = .orderedSame
    
    override open class var defaultTestSuite: XCTestSuite {
        let testSuite = XCTestSuite(name: NSStringFromClass(self))
        let simpleScore = "10hard/123soft";
        let lowHardScore = "10hard/987654321soft";
        let highHardScore = "987654321hard/123soft";
        addTest( 0, 0, simpleScore, simpleScore , to: testSuite ) // 0 - comparison according to soft score
        addTest( 0, 1, simpleScore, simpleScore , to: testSuite ) // 1 - no changes
        addTest( 0, 1024, simpleScore, simpleScore , to: testSuite ) // "huge" modifier
        addTest( -1, 0, simpleScore, lowHardScore , to: testSuite )
        addTest( -1, 1, simpleScore, lowHardScore , to: testSuite )
        addTest( -1, 1024, simpleScore, lowHardScore , to: testSuite )
        addTest( 1, 0, lowHardScore, simpleScore , to: testSuite )
        addTest( 1, 1, lowHardScore, simpleScore , to: testSuite )
        addTest( 1, 1024, lowHardScore, simpleScore , to: testSuite )
        addTest( 1, 0, lowHardScore, highHardScore , to: testSuite )
        addTest( -1, 1, lowHardScore, highHardScore , to: testSuite )
        addTest( -1, 1024, lowHardScore, highHardScore , to: testSuite )
        addTest( -1, 0, highHardScore, lowHardScore , to: testSuite )
        addTest( 1, 1, highHardScore, lowHardScore , to: testSuite )
        addTest( 1, 1024, highHardScore, lowHardScore , to: testSuite )
        addTest( 0, 0, highHardScore, simpleScore , to: testSuite )
        addTest( 1, 1, highHardScore, simpleScore , to: testSuite )
        addTest( 1, 1024, highHardScore, simpleScore , to: testSuite )
        return testSuite
    }
    
    // This is just to create the new ParameterizedExampleTests instance to add it into testSuite
    private class func addTest(
            _ expectedResult: Int,
            _ modifier: Int,
            _ firstScore: String,
            _ secondScore: String,
            to testSuite: XCTestSuite
    ) {
        for invocation in testInvocations {
            let testCase = FlatteningHardSoftScoreComparatorTest(invocation: invocation)
            testCase.modifier = modifier
            testCase.firstScore = firstScore
            testCase.secondScore = secondScore
            testCase.expectedResult = ComparisonResult(rawValue: expectedResult) ?? .orderedSame
            testSuite.addTest(testCase)
        }
    }
    
    func testComparator() {
        XCTAssertEqual(
            Comparators.ByFlatteningHardSoftScore(hardWeight: modifier)(
                HardSoftScoreDefinition().parseScore(firstScore),
                HardSoftScoreDefinition().parseScore(secondScore)
            ),
            expectedResult
        )
    }
    
}
