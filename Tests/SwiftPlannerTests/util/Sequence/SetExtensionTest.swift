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

public class SetExtensionTest : XCTestCase {
    
    func test_removeFirstEqual() {
        var set: Set<String> = [ "Set", "Extension" ]
        XCTAssertEqual(set.count, 2)
        XCTAssertTrue(set.removeFirstEqual("Extension"))
        XCTAssertEqual(set.count, 1)
    }
    
    func test_removeFirstEqual_2() {
        let score = SimpleScore.of(-20)
        let indictments = [TestdataObject(code: "e1")]
        let match = ConstraintMatch(
            constraintPackage: "package1",
            constraintName: "constraint2",
            justification: DefaultConstraintJustification.of(impact: score, facts: indictments),
            indictedObjects: indictments,
            score: score
        )
        var constraintMatchSet: Set<ConstraintMatch<SimpleScore>> = []
        XCTAssertTrue(constraintMatchSet.insert(match).inserted)
        XCTAssertTrue(constraintMatchSet.removeFirstEqual(match))
    }
    
}
