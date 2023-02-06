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

class HardSoftScoreTest : AbstractScoreTest {

    func test_of() {
        XCTAssertEqual(HardSoftScore.ofHard(-147), .of(hard: -147, soft: 0))
        XCTAssertEqual(HardSoftScore.ofSoft(-258), .of(hard: 0, soft: -258))
    }

    func test_parseScore() {
        XCTAssertEqual(HardSoftScore.parseScore("-147hard/-258soft"), .of(hard: -147, soft: -258))
        XCTAssertEqual(
            HardSoftScore.parseScore("-7init/-147hard/-258soft"),
            .ofUninitialized(init: -7, hard: -147, soft: -258)
        )
        XCTAssertEqual(HardSoftScore.parseScore("-147hard/*soft"), .of(hard: -147, soft: Int.min))
    }

    func test_toShortString() {
        XCTAssertEqual(HardSoftScore.of(hard: 0, soft: 0).toShortString(), "0")
        XCTAssertEqual(HardSoftScore.of(hard: 0, soft: -258).toShortString(), "-258soft")
        XCTAssertEqual(HardSoftScore.of(hard: -147, soft: 0).toShortString(), "-147hard")
        XCTAssertEqual(
            HardSoftScore.of(hard: -147, soft: -258).toShortString(),
            "-147hard/-258soft"
        )
        XCTAssertEqual(
            HardSoftScore.ofUninitialized(init: -7, hard: 0, soft: 0).toShortString(),
            "-7init"
        )
        XCTAssertEqual(
            HardSoftScore.ofUninitialized(init: -7, hard: 0, soft: -258).toShortString(),
            "-7init/-258soft"
        )
        XCTAssertEqual(
            HardSoftScore.ofUninitialized(init: -7, hard: -147, soft: -258).toShortString(),
            "-7init/-147hard/-258soft"
        )
    }

    func test_toString() {
        XCTAssertEqual(HardSoftScore.of(hard: 0, soft: -258).toString(), "0hard/-258soft")
        XCTAssertEqual(HardSoftScore.of(hard: -147, soft: -258).toString(), "-147hard/-258soft")
        XCTAssertEqual(
            HardSoftScore.ofUninitialized(init: -7, hard: -147, soft: -258).toString(),
            "-7init/-147hard/-258soft"
        )
    }

    func test_withInitScore() {
        XCTAssertEqual(
            HardSoftScore.of(hard: -147, soft: -258).withInitScore(-7),
            HardSoftScore.ofUninitialized(init: -7, hard: -147, soft: -258)
        )
    }

    func test_feasible() {
        Self.assertScoreNotFeasible(
            HardSoftScore.of(hard: -5, soft: -300),
            HardSoftScore.ofUninitialized(init: -7, hard: -5, soft: -300),
            HardSoftScore.ofUninitialized(init: -7, hard: 0, soft: -300)
        )
        Self.assertScoreFeasible(
            HardSoftScore.of(hard: 0, soft: -300),
            HardSoftScore.of(hard: 2, soft: -300),
            HardSoftScore.ofUninitialized(init: 0, hard: 0, soft: -300)
        )
    }

    func test_add() {
        XCTAssertEqual(
            HardSoftScore.of(hard: 20, soft: -20).add(.of(hard: -1, soft: -300)),
            HardSoftScore.of(hard: 19, soft: -320)
        )
        XCTAssertEqual(
            HardSoftScore.ofUninitialized(init: -70, hard: 20, soft: -20)
                .add(.ofUninitialized(init: -7, hard: -1, soft: -300)),
            HardSoftScore.ofUninitialized(init: -77, hard: 19, soft: -320)
        )
    }

    func test_subtract() {
        XCTAssertEqual(
            HardSoftScore.of(hard: 20, soft: -20).subtract(.of(hard: -1, soft: -300)),
            HardSoftScore.of(hard: 21, soft: 280)
        )
        XCTAssertEqual(
            HardSoftScore.ofUninitialized(init: -70, hard: 20, soft: -20)
                .subtract(.ofUninitialized(init: -7, hard: -1, soft: -300)),
            HardSoftScore.ofUninitialized(init: -63, hard: 21, soft: 280)
        )
    }

    func test_multiply() {
        XCTAssertEqual(HardSoftScore.of(hard: 5, soft: -5).multiply(1.2), .of(hard: 6, soft: -6))
        XCTAssertEqual(HardSoftScore.of(hard: 1, soft: -1).multiply(1.2), .of(hard: 1, soft: -2))
        XCTAssertEqual(HardSoftScore.of(hard: 4, soft: -4).multiply(1.2), .of(hard: 4, soft: -5))
        XCTAssertEqual(
            HardSoftScore.ofUninitialized(init: -7, hard: 4, soft: -5).multiply(2.0),
            HardSoftScore.ofUninitialized(init: -14, hard: 8, soft: -10)
        )
    }

    func test_divide() {
        XCTAssertEqual(HardSoftScore.of(hard: 25, soft: -25).divide(5.0), .of(hard: 5, soft: -5))
        XCTAssertEqual(HardSoftScore.of(hard: 21, soft: -21).divide(5.0), .of(hard: 4, soft: -5))
        XCTAssertEqual(HardSoftScore.of(hard: 24, soft: -24).divide(5.0), .of(hard: 4, soft: -5))
        XCTAssertEqual(
            HardSoftScore.ofUninitialized(init: -14, hard: 8, soft: -10).divide(2.0),
            HardSoftScore.ofUninitialized(init: -7, hard: 4, soft: -5)
        )
    }

    func test_power() {
        XCTAssertEqual(HardSoftScore.of(hard: -4, soft: 5).power(2.0), .of(hard: 16, soft: 25))
        XCTAssertEqual(HardSoftScore.of(hard: 16, soft: 25).power(0.5), .of(hard: 4, soft: 5))
        XCTAssertEqual(
            HardSoftScore.ofUninitialized(init: -7, hard: 4, soft: 5).power(3.0),
            HardSoftScore.ofUninitialized(init: -343, hard: 64, soft: 125)
        )
    }

    func test_negate() {
        XCTAssertEqual(HardSoftScore.of(hard: -4, soft: 5).negate(), .of(hard: 4, soft: -5))
        XCTAssertEqual(HardSoftScore.of(hard: 4, soft: -5).negate(), .of(hard: -4, soft: 5))
    }

    func test_abs() {
        XCTAssertEqual(HardSoftScore.of(hard: 4, soft: 5).abs(), .of(hard: 4, soft: 5))
        XCTAssertEqual(HardSoftScore.of(hard: -4, soft: 5).abs(), .of(hard: 4, soft: 5))
        XCTAssertEqual(HardSoftScore.of(hard: 4, soft: -5).abs(), .of(hard: 4, soft: 5))
        XCTAssertEqual(HardSoftScore.of(hard: -4, soft: -5).abs(), .of(hard: 4, soft: 5))
    }

    func test_zero() {
        continueAfterFailure = true // "soft assertions"
        let manualZero = HardSoftScore.of(hard: 0, soft: 0)
        XCTAssertEqual(manualZero.zero(), manualZero)
        XCTAssertTrue(manualZero.isZero())
        let manualOne = HardSoftScore.of(hard: 0, soft: 1)
        XCTAssertFalse(manualOne.isZero())
    }

    func test_equalsAndHashCode() {
        PlannerAssert.assertObjectsAreEqual(
            HardSoftScore.of(hard: -10, soft: -200),
            HardSoftScore.of(hard: -10, soft: -200),
            HardSoftScore.ofUninitialized(init: 0, hard: -10, soft: -200)
        )
        PlannerAssert.assertObjectsAreEqual(
            HardSoftScore.ofUninitialized(init: -7, hard: -10, soft: -200),
            HardSoftScore.ofUninitialized(init: -7, hard: -10, soft: -200)
        )
        PlannerAssert.assertObjectsAreNotEqual(
            HardSoftScore.of(hard: -10, soft: -200),
            HardSoftScore.of(hard: -30, soft: -200),
            HardSoftScore.of(hard: -10, soft: -400),
            HardSoftScore.ofUninitialized(init: -7, hard: -10, soft: -200)
        )
    }

    func test_compareTo() {
        PlannerAssert.assertCompareToOrder(
            HardSoftScore.ofUninitialized(init: -8, hard: 0, soft: 0),
            HardSoftScore.ofUninitialized(init: -7, hard: -20, soft: -20),
            HardSoftScore.ofUninitialized(init: -7, hard: -1, soft: -300),
            HardSoftScore.ofUninitialized(init: -7, hard: 0, soft: 0),
            HardSoftScore.ofUninitialized(init: -7, hard: 0, soft: 1),
            HardSoftScore.of(hard: -20, soft: Int.min),
            HardSoftScore.of(hard: -20, soft: -20),
            HardSoftScore.of(hard: -1, soft: -300),
            HardSoftScore.of(hard: -1, soft: 4000),
            HardSoftScore.of(hard: 0, soft: -1),
            HardSoftScore.of(hard: 0, soft: 0),
            HardSoftScore.of(hard: 0, soft: 1)
        )
    }
    
}
