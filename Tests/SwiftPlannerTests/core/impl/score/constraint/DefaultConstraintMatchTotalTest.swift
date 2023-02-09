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

class DefaultConstraintMatchTotalTest : XCTestCase {

    func test_getScoreTotal() {
        // WIP: Replace all three with TestdataEntity
        let e1 = TestdataObject(code: "e1")
        let e2 = TestdataObject(code: "e2")
        let e3 = TestdataObject(code: "e3")
        let constraintMatchTotal = DefaultConstraintMatchTotal(
            package: "package1",
            name: "constraint1",
            weight: SimpleScore.ZERO
        )
        XCTAssertEqual(constraintMatchTotal.getScore(), SimpleScore.ZERO)

        /*let match1*/ _ = constraintMatchTotal.addConstraintMatch(
            justifications: [e1, e2],
            score: SimpleScore.of(-1)
        )
        XCTAssertEqual(constraintMatchTotal.getScore(), SimpleScore.of(-1))
        /*let match2*/ _ = constraintMatchTotal.addConstraintMatch(
            justifications: [e1, e3],
            score: SimpleScore.of(-20)
        )
        XCTAssertEqual(constraintMatchTotal.getScore(), SimpleScore.of(-21))
        // Almost duplicate, but e2 and e1 are in reverse order, so different justification
        /*let match3*/ _ = constraintMatchTotal.addConstraintMatch(
            justifications: [e2, e1],
            score: SimpleScore.of(-300)
        )
        XCTAssertEqual(constraintMatchTotal.getScore(), SimpleScore.of(-321))

        /* WIP: Implement last part of DefaultConstraintJustification.getClassAndIdPlanningComparator
        constraintMatchTotal.removeConstraintMatch(match2)
        XCTAssertEqual(constraintMatchTotal.getScore(), SimpleScore.of(-301))
        constraintMatchTotal.removeConstraintMatch(match1)
        XCTAssertEqual(constraintMatchTotal.getScore(), SimpleScore.of(-300))
        constraintMatchTotal.removeConstraintMatch(match3)
        XCTAssertEqual(constraintMatchTotal.getScore(), SimpleScore.ZERO)
         */
    }

    func test_equalsAndHashCode() {
        PlannerAssert.assertObjectsAreEqual(
            DefaultConstraintMatchTotal(package: "a.b", name: "c", weight: SimpleScore.ZERO),
            DefaultConstraintMatchTotal(package: "a.b", name: "c", weight: SimpleScore.ZERO),
            DefaultConstraintMatchTotal(package: "a.b", name: "c", weight: SimpleScore.of(-7)
                                             )
        )
        PlannerAssert.assertObjectsAreNotEqual(
            DefaultConstraintMatchTotal(package: "a.b", name: "c", weight: SimpleScore.ZERO),
            DefaultConstraintMatchTotal(package: "a.b", name: "d", weight: SimpleScore.ZERO),
            DefaultConstraintMatchTotal(package: "a.c", name: "d", weight: SimpleScore.ZERO)
        )
    }

    func test_compareTo() {
        PlannerAssert.assertCompareToOrder(
            DefaultConstraintMatchTotal(package: "a.b", name: "aa", weight: SimpleScore.ZERO),
             DefaultConstraintMatchTotal(package: "a.b", name: "ab", weight: SimpleScore.ZERO),
             DefaultConstraintMatchTotal(package: "a.b", name: "ca", weight: SimpleScore.ZERO),
             DefaultConstraintMatchTotal(package: "a.b", name: "cb", weight: SimpleScore.ZERO),
             DefaultConstraintMatchTotal(package: "a.b", name: "d", weight: SimpleScore.ZERO),
             DefaultConstraintMatchTotal(package: "a.c", name: "a", weight: SimpleScore.ZERO),
             DefaultConstraintMatchTotal(package: "a.c", name: "b", weight: SimpleScore.ZERO),
             DefaultConstraintMatchTotal(package: "a.c", name: "c", weight: SimpleScore.ZERO)
        )
    }

}
