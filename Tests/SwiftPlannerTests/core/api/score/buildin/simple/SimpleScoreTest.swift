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

class SimpleScoreTest : AbstractScoreTest {

    func test_parseScore() {
        XCTAssertEqual(SimpleScore.parseScore("-147"), SimpleScore.of(-147))
        XCTAssertEqual(
            SimpleScore.parseScore("-7init/-147"),
            SimpleScore.ofUninitialized(initScore: -7, score: -147)
        )
        XCTAssertEqual(SimpleScore.parseScore("*"), SimpleScore.of(Int.min))
    }

    func test_toShortString() {
        XCTAssertEqual(SimpleScore.of(0).toShortString(), "0")
        XCTAssertEqual(SimpleScore.of(-147).toShortString(), "-147")
        XCTAssertEqual(
            SimpleScore.ofUninitialized(initScore: -7, score: -147).toShortString(),
            "-7init/-147"
        )
        XCTAssertEqual(
            SimpleScore.ofUninitialized(initScore: -7, score: 0).toShortString(),
            "-7init"
        )
    }

    func test_testToString() {
        XCTAssertEqual(SimpleScore.of(0).toString(), "0")
        XCTAssertEqual(SimpleScore.of(-147).toString(), "-147")
        XCTAssertEqual(
            SimpleScore.ofUninitialized(initScore: -7, score: -147).toString(),
            "-7init/-147"
        )
    }

    func test_withInitScore() {
        XCTAssertEqual(
            SimpleScore.of(-147).withInitScore(-7),
            SimpleScore.ofUninitialized(initScore: -7, score: -147)
        )
    }

    func test_add() {
        XCTAssertEqual(SimpleScore.of(20).add(SimpleScore.of(-1)), SimpleScore.of(19))
        XCTAssertEqual(
            SimpleScore.ofUninitialized(initScore: -70, score: 20)
                .add(.ofUninitialized(initScore: -7, score: -1)),
            SimpleScore.ofUninitialized(initScore: -77, score: 19)
        )
    }

    func test_subtract() {
        XCTAssertEqual(SimpleScore.of(20).subtract(SimpleScore.of(-1)), SimpleScore.of(21))
        XCTAssertEqual(
            SimpleScore.ofUninitialized(initScore: -70, score: 20)
                .subtract(.ofUninitialized(initScore: -7, score: -1)),
            SimpleScore.ofUninitialized(initScore: -63, score: 21)
        )
    }

    func test_multiply() {
        XCTAssertEqual(SimpleScore.of(5).multiply(1.2), SimpleScore.of(6))
        XCTAssertEqual(SimpleScore.of(1).multiply(1.2), SimpleScore.of(1))
        XCTAssertEqual(SimpleScore.of(4).multiply(1.2), SimpleScore.of(4))
        XCTAssertEqual(
            SimpleScore.ofUninitialized(initScore: -7, score: 4).multiply(2.0),
            SimpleScore.ofUninitialized(initScore: -14, score: 8)
        )
    }

    func test_divide() {
        XCTAssertEqual(SimpleScore.of(25).divide(5.0), SimpleScore.of(5))
        XCTAssertEqual(SimpleScore.of(21).divide(5.0), SimpleScore.of(4))
        XCTAssertEqual(SimpleScore.of(24).divide(5.0), SimpleScore.of(4))
        XCTAssertEqual(
            SimpleScore.ofUninitialized(initScore: -14, score: 8).divide(2.0),
            SimpleScore.ofUninitialized(initScore: -7, score: 4)
        )
    }

    func test_power() {
        XCTAssertEqual(SimpleScore.of(5).power(2.0),SimpleScore.of(25))
        XCTAssertEqual(SimpleScore.of(25).power(0.5), SimpleScore.of(5))
        XCTAssertEqual(
            SimpleScore.ofUninitialized(initScore: -7, score: 5).power(3.0),
            SimpleScore.ofUninitialized(initScore: -343, score: 125)
        )
    }

    func test_negate() {
        XCTAssertEqual(SimpleScore.of(5).negate(), SimpleScore.of(-5))
        XCTAssertEqual(SimpleScore.of(-5).negate(), SimpleScore.of(5))
    }

    func test_abs() {
        XCTAssertEqual(SimpleScore.of(5).abs(), SimpleScore.of(5))
        XCTAssertEqual(SimpleScore.of(-5).abs(), SimpleScore.of(5))
    }

    func test_zero() {
        continueAfterFailure = true // "soft assertions"
        let manualZero = SimpleScore.of(0)
        XCTAssertEqual(manualZero.zero(), manualZero)
        XCTAssertTrue(manualZero.isZero())
        let manualOne = SimpleScore.of(1)
        XCTAssertFalse(manualOne.isZero())
    }

    func test_equalsAndHashCode() {
        PlannerAssert.assertObjectsAreEqual(
            SimpleScore.of(-10),
            SimpleScore.of(-10),
            SimpleScore.ofUninitialized(initScore: 0, score: -10)
        )
        PlannerAssert.assertObjectsAreEqual(
            SimpleScore.ofUninitialized(initScore: -7, score: -10),
            SimpleScore.ofUninitialized(initScore: -7, score: -10)
        )
        PlannerAssert.assertObjectsAreNotEqual(
            SimpleScore.of(-10),
            SimpleScore.of(-30),
            SimpleScore.ofUninitialized(initScore: -7, score: -10)
        )
    }

    func test_compareTo() {
        PlannerAssert.assertCompareToOrder(
            SimpleScore.ofUninitialized(initScore: -8, score: 0),
            SimpleScore.ofUninitialized(initScore: -7, score: -20),
            SimpleScore.ofUninitialized(initScore: -7, score: -1),
            SimpleScore.ofUninitialized(initScore: -7, score: 0),
            SimpleScore.ofUninitialized(initScore: -7, score: 1),
            SimpleScore.of(-300),
            SimpleScore.of(-20),
            SimpleScore.of(-1),
            SimpleScore.of(0),
            SimpleScore.of(1)
        )
    }
    
}
