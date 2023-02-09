//
/*
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
 */

import XCTest
@testable import SwiftPlanner

public class EqualsTest : XCTestCase {
    
    func test_check_1() {
        let testObject = TestdataObject(code: "e1")
        let testObject2 = TestdataObject(code: "e2")
        XCTAssertTrue(Equals.check(testObject, testObject))
        XCTAssertFalse(Equals.check(testObject, testObject2))
    }
    
    func test_check_2() {
        let testObject = TestdataObject(code: "e1")
        let testObject2 = TestdataObject(code: "e5")
        XCTAssertTrue(Equals.check(testObject, testObject, orElse: { false }))
        XCTAssertFalse(Equals.check(testObject, testObject2, orElse: { true }))
    }
    
    func test_check_3() {
        let score = SimpleScore.of(-20)
        let indictments = [TestdataObject(code: "e1")]
        let match = ConstraintMatch(
            constraintPackage: "package1",
            constraintName: "constraint2",
            justification: DefaultConstraintJustification.of(impact: score, facts: indictments),
            indictedObjects: indictments,
            score: score
        )
        let score2 = SimpleScore.of(-20)
        let indictments2 = [TestdataObject(code: "e2")]
        let match2 = ConstraintMatch(
            constraintPackage: "package1",
            constraintName: "constraint2",
            justification: DefaultConstraintJustification.of(impact: score2, facts: indictments2),
            indictedObjects: indictments2,
            score: score2
        )
        XCTAssertTrue(Equals.check(match, match, orElse: { false }))
        XCTAssertFalse(Equals.check(match, match2, orElse: { true }))
    }
    
}
