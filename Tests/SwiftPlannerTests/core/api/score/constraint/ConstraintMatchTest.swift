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

// WIP: Implement DefaultConstraintJustification.getClassAndIdPlanningComparator

import XCTest
@testable import SwiftPlanner

class ConstraintMatchTest : XCTestCase {

    private let ZERO = SimpleScore.ZERO
    
    func test_equalsAndHashCode() { // No CM should equal any other.
        let constraintMatch = buildConstraintMatch("a. b", "c", ZERO, "e1")
        PlannerAssert.assertObjectsAreEqualWithoutComparing([constraintMatch, constraintMatch])
        let constraintMatch2 = buildConstraintMatch("a. b", "c", ZERO, "e1")
        // Special call to avoid Comparable checks.
        PlannerAssert.assertObjectsAreNotEqualWithoutComparing([constraintMatch, constraintMatch2])
    }

    private func buildConstraintMatch<Score_ : Score>(
            _ constraintPackage: String,
            _ constraintName: String,
            _ score: Score_,
            _ indictments: CustomStringConvertible...
    ) -> ConstraintMatch<Score_> {
        return ConstraintMatch(
            constraintPackage: constraintPackage,
            constraintName: constraintName,
            justification: DefaultConstraintJustification.of(score, facts: indictments),
            indictedObjects: indictments,
            score: score
        )
    }

    func test_compareTo() {
        PlannerAssert.assertCompareToOrder(
            buildConstraintMatch("a.b", "a", ZERO, "a"),
            buildConstraintMatch("a.b", "a", ZERO, "a", "aa"),
            buildConstraintMatch("a.b", "a", ZERO, "a", "ab"),
            buildConstraintMatch("a.b", "a", ZERO, "a", "c"),
            buildConstraintMatch("a.b", "a", ZERO, "a", "aa", "a"),
            buildConstraintMatch("a.b", "a", ZERO, "a", "aa", "b"),
            buildConstraintMatch("a.b", "a", SimpleScore.ONE, "a", "aa"),
            buildConstraintMatch("a.b", "b", ZERO, "a", "aa"),
            buildConstraintMatch("a.b", "b", ZERO, "a", "ab"),
            buildConstraintMatch("a.b", "b", ZERO, "a", "c"),
            buildConstraintMatch("a.c", "a", ZERO, "a", "aa"),
            buildConstraintMatch("a.c", "a", ZERO, "a", "ab"),
            buildConstraintMatch("a.c", "a", ZERO, "a", "c")
        )
    }
    

}
