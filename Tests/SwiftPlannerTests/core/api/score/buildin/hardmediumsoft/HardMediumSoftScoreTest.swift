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

class HardMediumSoftScoreTest : AbstractScoreTest {

    func test_of() {
        XCTAssertEqual(HardMediumSoftScore.ofHard(-147), .of(hard: -147, medium: 0, soft: 0))
        XCTAssertEqual(HardMediumSoftScore.ofMedium(-258), .of(hard: 0, medium: -258, soft: 0))
        XCTAssertEqual(HardMediumSoftScore.ofSoft(-369), .of(hard: 0, medium: 0, soft: -369))
    }

    func test_parseScore() {
        XCTAssertEqual(
            HardMediumSoftScore.parseScore("-147hard/-258medium/-369soft"),
            .of(hard: -147, medium: -258, soft: -369)
        )
        XCTAssertEqual(
            HardMediumSoftScore.parseScore("-7init/-147hard/-258medium/-369soft"),
            .ofUninitialized(init: -7, hard: -147, medium: -258, soft: -369)
        )
        XCTAssertEqual(
            HardMediumSoftScore.parseScore("-147hard/-258medium/*soft"),
            .of(hard: -147, medium: -258, soft: Int.min)
        )
        XCTAssertEqual(
            HardMediumSoftScore.parseScore("-147hard/*medium/-369soft"),
            .of(hard: -147, medium: Int.min, soft: -369)
        )
    }

    func test_toShortString() {
        XCTAssertEqual(HardMediumSoftScore.of(hard: 0, medium: 0, soft: 0).toShortString(), "0")
        XCTAssertEqual(
            HardMediumSoftScore.of(hard: 0, medium: 0, soft: -369).toShortString(),
            "-369soft"
        )
        XCTAssertEqual(
            HardMediumSoftScore.of(hard: 0, medium: -258, soft: 0).toShortString(),
            "-258medium"
        )
        XCTAssertEqual(
            HardMediumSoftScore.of(hard: 0, medium: -258, soft: -369).toShortString(),
            "-258medium/-369soft"
        )
        XCTAssertEqual(
            HardMediumSoftScore.of(hard: -147, medium: -258, soft: -369).toShortString(),
            "-147hard/-258medium/-369soft"
        )
        XCTAssertEqual(
            HardMediumSoftScore.ofUninitialized(init: -7, hard: 0, medium: -258, soft: 0)
                .toShortString(),
            "-7init/-258medium"
        )
        XCTAssertEqual(
            HardMediumSoftScore.ofUninitialized(init: -7, hard: -147, medium: -258, soft: -369)
                .toShortString(),
            "-7init/-147hard/-258medium/-369soft"
        )
    }

    func test_toString() {
        XCTAssertEqual(
            HardMediumSoftScore.of(hard: 0, medium: -258, soft: -369).toString(),
            "0hard/-258medium/-369soft"
        )
        XCTAssertEqual(
            HardMediumSoftScore.of(hard: -147, medium: -258, soft: -369).toString(),
            "-147hard/-258medium/-369soft"
        )
        XCTAssertEqual(
            HardMediumSoftScore.ofUninitialized(init: -7, hard: -147, medium: -258, soft: -369)
                .toString(),
            "-7init/-147hard/-258medium/-369soft"
        )
    }
    /*
    func test_parseScoreIllegalArgument() {
        XCTExpectFailure("assert fail is expected")
        _ = HardMediumSoftScore.parseScore("-147")
        //assertThatIllegalArgumentException().isThrownBy(() -> HardMediumSoftScore.parseScore("-147"));
    }
    */
    func test_withInitScore() {
        XCTAssertEqual(
            HardMediumSoftScore.of(hard: -147, medium: -258, soft: -369).withInitScore(-7),
            .ofUninitialized(init: -7, hard: -147, medium: -258, soft: -369)
        )
    }

    func test_feasible() {
        Self.assertScoreNotFeasible(
            HardMediumSoftScore.of(hard: -5, medium: -300, soft: -4000),
            HardMediumSoftScore.ofUninitialized(init: -7, hard: -5, medium: -300, soft: -4000),
            HardMediumSoftScore.ofUninitialized(init: -7, hard: 0, medium: -300, soft: -4000)
        )
        Self.assertScoreFeasible(
            HardMediumSoftScore.of(hard: 0, medium: -300, soft: -4000),
            HardMediumSoftScore.of(hard: 2, medium: -300, soft: -4000),
            HardMediumSoftScore.ofUninitialized(init: 0, hard: 0, medium: -300, soft: -4000)
        )
    }

    func test_add() {
        XCTAssertEqual(
            HardMediumSoftScore.of(hard: 20, medium: -20, soft: -4000)
                .add(.of(hard: -1, medium: -300, soft: 4000)),
            HardMediumSoftScore.of(hard: 19, medium: -320, soft: 0)
        )
        XCTAssertEqual(
            HardMediumSoftScore.ofUninitialized(init: -70, hard: 20, medium: -20, soft: -4000)
                .add(.ofUninitialized(init: -7, hard: -1, medium: -300, soft: 4000)),
            HardMediumSoftScore.ofUninitialized(init: -77, hard: 19, medium: -320, soft: 0)
        )
    }

    func test_subtract() {
        XCTAssertEqual(
            HardMediumSoftScore.of(hard: 20, medium: -20, soft: -4000)
                .subtract(.of(hard: -1, medium: -300, soft: 4000)),
            HardMediumSoftScore.of(hard: 21, medium: 280, soft: -8000)
        )
        XCTAssertEqual(
            HardMediumSoftScore.ofUninitialized(init: -70, hard: 20, medium: -20, soft: -4000)
                .subtract(.ofUninitialized(init: -7, hard: -1, medium: -300, soft: 4000)),
            HardMediumSoftScore.ofUninitialized(init: -63, hard: 21, medium: 280, soft: -8000)
        )
    }

    func test_multiply() {
        XCTAssertEqual(
            HardMediumSoftScore.of(hard: 5, medium: -5, soft: 5).multiply(1.2),
            HardMediumSoftScore.of(hard: 6, medium: -6, soft: 6)
        )
        XCTAssertEqual(
            HardMediumSoftScore.of(hard: 1, medium: -1, soft: 1).multiply(1.2),
            HardMediumSoftScore.of(hard: 1, medium: -2, soft: 1)
        )
        XCTAssertEqual(
            HardMediumSoftScore.of(hard: 4, medium: -4, soft: 4).multiply(1.2),
            HardMediumSoftScore.of(hard: 4, medium: -5, soft: 4)
        )
        XCTAssertEqual(
            HardMediumSoftScore.ofUninitialized(init: -7, hard: 4, medium: -5, soft: 6)
                .multiply(2.0),
            HardMediumSoftScore.ofUninitialized(init: -14, hard: 8, medium: -10, soft: 12)
        )
    }

    func test_divide() {
        XCTAssertEqual(
            HardMediumSoftScore.of(hard: 25, medium: -25, soft: 25).divide(5.0),
            HardMediumSoftScore.of(hard: 5, medium: -5, soft: 5)
        )
        XCTAssertEqual(
            HardMediumSoftScore.of(hard: 21, medium: -21, soft: 21).divide(5.0),
            HardMediumSoftScore.of(hard: 4, medium: -5, soft: 4)
        )
        XCTAssertEqual(
            HardMediumSoftScore.of(hard: 24, medium: -24, soft: 24).divide(5.0),
            HardMediumSoftScore.of(hard: 4, medium: -5, soft: 4)
        )
        XCTAssertEqual(
            .ofUninitialized(init: -14, hard: 8, medium: -10, soft: 12).divide(2.0),
            HardMediumSoftScore.ofUninitialized(init: -7, hard: 4, medium: -5, soft: 6)
        )
    }

    func test_power() {
        XCTAssertEqual(
            HardMediumSoftScore.of(hard: 3, medium: -4, soft: 5).power(2.0),
            HardMediumSoftScore.of(hard: 9, medium: 16, soft: 25)
        )
        XCTAssertEqual(
            HardMediumSoftScore.of(hard: 9, medium: 16, soft: 25).power(0.5),
            HardMediumSoftScore.of(hard: 3, medium: 4, soft: 5)
        )
        XCTAssertEqual(
            HardMediumSoftScore.ofUninitialized(init: -7, hard: 3, medium: -4, soft: 5).power(3.0),
            HardMediumSoftScore.ofUninitialized(init: -343, hard: 27, medium: -64, soft: 125)
        )
    }

    func test_negate() {
        XCTAssertEqual(
            HardMediumSoftScore.of(hard: 3, medium: -4, soft: 5).negate(),
            HardMediumSoftScore.of(hard: -3, medium: 4, soft: -5)
        )
        XCTAssertEqual(
            HardMediumSoftScore.of(hard: -3, medium: 4, soft: -5).negate(),
            HardMediumSoftScore.of(hard: 3, medium: -4, soft: 5)
        )
    }

    func test_abs() {
        XCTAssertEqual(
            HardMediumSoftScore.of(hard: 3, medium: 4, soft: 5).abs(),
            HardMediumSoftScore.of(hard: 3, medium: 4, soft: 5)
        )
        XCTAssertEqual(
            HardMediumSoftScore.of(hard: 3, medium: -4, soft: 5).abs(),
            HardMediumSoftScore.of(hard: 3, medium: 4, soft: 5)
        )
        XCTAssertEqual(
            HardMediumSoftScore.of(hard: -3, medium: 4, soft: -5).abs(),
            HardMediumSoftScore.of(hard: 3, medium: 4, soft: 5)
        )
        XCTAssertEqual(
            HardMediumSoftScore.of(hard: -3, medium: -4, soft: -5).abs(),
            HardMediumSoftScore.of(hard: 3, medium: 4, soft: 5)
        )
    }

    func test_zero() {
        continueAfterFailure = true // "soft assertions"
        let manualZero = HardMediumSoftScore.of(hard: 0, medium: 0, soft: 0)
        XCTAssertEqual(manualZero.zero(), manualZero)
        XCTAssertTrue(manualZero.isZero())
        let manualOne = HardMediumSoftScore.of(hard: 0, medium: 0, soft: 1)
        XCTAssertFalse(manualOne.isZero())
    }
    
    func test_equalsAndHashCode() {
        PlannerAssert.assertObjectsAreEqual(
            HardMediumSoftScore.of(hard: -10, medium: -200, soft: -3000),
            HardMediumSoftScore.of(hard: -10, medium: -200, soft: -3000),
            HardMediumSoftScore.ofUninitialized(init: 0, hard: -10, medium: -200, soft: -3000)
        )
        PlannerAssert.assertObjectsAreEqual(
            HardMediumSoftScore.ofUninitialized(init: -7, hard: -10, medium: -200, soft: -3000),
            HardMediumSoftScore.ofUninitialized(init: -7, hard: -10, medium: -200, soft: -3000)
        )
        PlannerAssert.assertObjectsAreNotEqual(
            HardMediumSoftScore.of(hard: -10, medium: -200, soft: -3000),
            HardMediumSoftScore.of(hard: -30, medium: -200, soft: -3000),
            HardMediumSoftScore.of(hard: -10, medium: -400, soft: -3000),
            HardMediumSoftScore.of(hard: -10, medium: -400, soft: -5000),
            HardMediumSoftScore.ofUninitialized(init: -7, hard: -10, medium: -200, soft: -3000)
        )
    }

    func test_compareTo() {
        PlannerAssert.assertCompareToOrder(
            HardMediumSoftScore.ofUninitialized(init: -8, hard: 0, medium: 0, soft: 0),
            HardMediumSoftScore.ofUninitialized(init: -7, hard: -20, medium: -20, soft: -20),
            HardMediumSoftScore.ofUninitialized(init: -7, hard: -1, medium: -300, soft: -4000),
            HardMediumSoftScore.ofUninitialized(init: -7, hard: 0, medium: 0, soft: 0),
            HardMediumSoftScore.ofUninitialized(init: -7, hard: 0, medium: 0, soft: 1),
            HardMediumSoftScore.ofUninitialized(init: -7, hard: 0, medium: 1, soft: 0),
            HardMediumSoftScore.of(hard: -20, medium: Int.min, soft: Int.min),
            HardMediumSoftScore.of(hard: -20, medium: Int.min, soft: -20),
            HardMediumSoftScore.of(hard: -20, medium: Int.min, soft: 1),
            HardMediumSoftScore.of(hard: -20, medium: -300, soft: -4000),
            HardMediumSoftScore.of(hard: -20, medium: -300, soft: -300),
            HardMediumSoftScore.of(hard: -20, medium: -300, soft: -20),
            HardMediumSoftScore.of(hard: -20, medium: -300, soft: 300),
            HardMediumSoftScore.of(hard: -20, medium: -20, soft: -300),
            HardMediumSoftScore.of(hard: -20, medium: -20, soft: 0),
            HardMediumSoftScore.of(hard: -20, medium: -20, soft: 1),
            HardMediumSoftScore.of(hard: -1, medium: -300, soft: -4000),
            HardMediumSoftScore.of(hard: -1, medium: -300, soft: -20),
            HardMediumSoftScore.of(hard: -1, medium: -20, soft: -300),
            HardMediumSoftScore.of(hard: 1, medium: Int.min, soft: -20),
            HardMediumSoftScore.of(hard: 1, medium: -20, soft: Int.min)
        )
    }
 
}
