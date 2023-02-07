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

class BendableScoreTest : AbstractScoreTest {

    private let scoreDefinitionHSS = BendableScoreDefinition(hardLevelsSize: 1, softLevelsSize: 2)
    private let scoreDefinitionHHH = BendableScoreDefinition(hardLevelsSize: 3, softLevelsSize: 0)
    private let scoreDefinitionSSS = BendableScoreDefinition(hardLevelsSize: 0, softLevelsSize: 3)

    func test_of() {
        XCTAssertEqual(
            .ofHard(hardLevelsSize: 1, softLevelsSize: 2, hardLevel: 0, hardScore: -147),
            scoreDefinitionHSS.createScore(-147, 0, 0)
        )
        XCTAssertEqual(
            .ofSoft(hardLevelsSize: 1, softLevelsSize: 2, softLevel: 0, softScore: -258),
            scoreDefinitionHSS.createScore(0, -258, 0)
        )
        XCTAssertEqual(
            .ofSoft(hardLevelsSize: 1, softLevelsSize: 2, softLevel: 1, softScore: -369),
            scoreDefinitionHSS.createScore(0, 0, -369)
        )
        XCTAssertEqual(
            .ofHard(hardLevelsSize: 3, softLevelsSize: 0, hardLevel: 2, hardScore: -369),
            scoreDefinitionHHH.createScore(0, 0, -369)
        )
        XCTAssertEqual(
            .ofSoft(hardLevelsSize: 0, softLevelsSize: 3, softLevel: 2, softScore: -369),
            scoreDefinitionSSS.createScore(0, 0, -369)
        )
    }

    func test_parseScore() {
        XCTAssertEqual(
            scoreDefinitionHSS.parseScore("[-147]hard/[-258/-369]soft"),
            scoreDefinitionHSS.createScore(-147, -258, -369)
        )
        XCTAssertEqual(
            scoreDefinitionHHH.parseScore("[-147/-258/-369]hard/[]soft"),
            scoreDefinitionHHH.createScore(-147, -258, -369)
        )
        XCTAssertEqual(
            scoreDefinitionSSS.parseScore("[]hard/[-147/-258/-369]soft"),
            scoreDefinitionSSS.createScore(-147, -258, -369)
        )
        XCTAssertEqual(
            scoreDefinitionSSS.parseScore("-7init/[]hard/[-147/-258/-369]soft"),
            scoreDefinitionSSS.createScoreUninitialized(initScore: -7, scores: -147, -258, -369)
        )
        XCTAssertEqual(
            scoreDefinitionHSS.parseScore("[-147]hard/[-258/*]soft"),
            scoreDefinitionHSS.createScore(-147, -258, Int.min)
        )
        XCTAssertEqual(
            scoreDefinitionHSS.parseScore("[-147]hard/[*/-369]soft"),
            scoreDefinitionHSS.createScore(-147, Int.min, -369)
        )
    }

    func test_toShortString() {
        XCTAssertEqual(scoreDefinitionHSS.createScore(0, 0, 0).toShortString(), "0")
        XCTAssertEqual(scoreDefinitionHSS.createScore(0, 0, -369).toShortString(), "[0/-369]soft")
        XCTAssertEqual(
            scoreDefinitionHSS.createScore(0, -258, -369).toShortString(),
            "[-258/-369]soft"
        )
        XCTAssertEqual(scoreDefinitionHSS.createScore(-147, 0, 0).toShortString(), "[-147]hard")
        XCTAssertEqual(
            scoreDefinitionHSS.createScore(-147, -258, -369).toShortString(),
            "[-147]hard/[-258/-369]soft"
        )
        XCTAssertEqual(
            scoreDefinitionHHH.createScore(-147, -258, -369).toShortString(),
            "[-147/-258/-369]hard"
        )
        XCTAssertEqual(
            scoreDefinitionSSS.createScore(-147, -258, -369).toShortString(),
            "[-147/-258/-369]soft"
        )
        XCTAssertEqual(
            scoreDefinitionSSS.createScoreUninitialized(initScore: -7, scores: -147, -258, -369)
                .toShortString(),
            "-7init/[-147/-258/-369]soft"
        )
    }

    func test_toString() {
        XCTAssertEqual(
            scoreDefinitionHSS.createScore(0, -258, -369).toString(),
            "[0]hard/[-258/-369]soft"
        )
        XCTAssertEqual(
            scoreDefinitionHSS.createScore(-147, -258, -369).toString(),
            "[-147]hard/[-258/-369]soft"
        )
        XCTAssertEqual(
            scoreDefinitionHHH.createScore(-147, -258, -369).toString(),
            "[-147/-258/-369]hard/[]soft"
        )
        XCTAssertEqual(
            scoreDefinitionSSS.createScore(-147, -258, -369).toString(),
            "[]hard/[-147/-258/-369]soft"
        )
        XCTAssertEqual(
            scoreDefinitionSSS.createScoreUninitialized(initScore: -7, scores: -147, -258, -369)
                .toString(),
            "-7init/[]hard/[-147/-258/-369]soft"
        )
        XCTAssertEqual(
            BendableScoreDefinition(hardLevelsSize: 0, softLevelsSize: 0).createScore().toString(),
            "[]hard/[]soft"
        )
    }

    func test_getHardOrSoftScore() {
        let initializedScore = scoreDefinitionHSS.createScore(-5, -10, -200)
        XCTAssertEqual(initializedScore.hardOrSoftScore(level: 0), -5)
        XCTAssertEqual(initializedScore.hardOrSoftScore(level: 1), -10)
        XCTAssertEqual(initializedScore.hardOrSoftScore(level: 2), -200)
    }

    func test_withInitScore() {
        XCTAssertEqual(
            scoreDefinitionHSS.createScore(-147, -258, -369).withInitScore(-7),
            scoreDefinitionHSS.createScoreUninitialized(initScore: -7, scores: -147, -258, -369)
        )
    }

    func test_feasibleHSS() {
        Self.assertScoreNotFeasible(
            scoreDefinitionHSS.createScore(-20, -300, -4000),
            scoreDefinitionHSS.createScoreUninitialized(initScore: -1, scores: 20, -300, -4000),
            scoreDefinitionHSS.createScoreUninitialized(initScore: -1, scores: 0, -300, -4000),
            scoreDefinitionHSS.createScoreUninitialized(initScore: -1, scores: -20, -300, -4000)
        )
        Self.assertScoreFeasible(
            scoreDefinitionHSS.createScore(0, -300, -4000),
            scoreDefinitionHSS.createScore(20, -300, -4000),
            scoreDefinitionHSS.createScoreUninitialized(initScore: 0, scores: 0, -300, -4000)
        )
    }

    func test_addHSS() {
        XCTAssertEqual(
            scoreDefinitionHSS.createScore(20, -20, -4000)
                .add(scoreDefinitionHSS.createScore(-1, -300, 4000)),
            scoreDefinitionHSS.createScore(19, -320, 0)
        )
        XCTAssertEqual(
            scoreDefinitionHSS.createScoreUninitialized(initScore: -70, scores: 20, -20, -4000)
                .add(scoreDefinitionHSS.createScoreUninitialized(
                    initScore: -7,
                    scores: -1, -300, 4000
                )),
            scoreDefinitionHSS.createScoreUninitialized(initScore: -77, scores: 19, -320, 0)
        )
    }

    func test_subtractHSS() {
        XCTAssertEqual(
            scoreDefinitionHSS.createScore(20, -20, -4000)
                .subtract(scoreDefinitionHSS.createScore(-1, -300, 4000)),
            scoreDefinitionHSS.createScore(21, 280, -8000)
        )
        XCTAssertEqual(
            scoreDefinitionHSS.createScoreUninitialized(initScore: -70, scores: 20, -20, -4000)
                .subtract(scoreDefinitionHSS.createScoreUninitialized(
                    initScore: -7,
                    scores: -1, -300, 4000
                )),
            scoreDefinitionHSS.createScoreUninitialized(initScore: -63, scores: 21, 280, -8000)
        )
    }

    func test_multiplyHSS() {
        XCTAssertEqual(
            scoreDefinitionHSS.createScore(5, -5, 5).multiply(1.2),
            scoreDefinitionHSS.createScore(6, -6, 6)
        )
        XCTAssertEqual(
            scoreDefinitionHSS.createScore(1, -1, 1).multiply(1.2),
            scoreDefinitionHSS.createScore(1, -2, 1)
        )
        XCTAssertEqual(
            scoreDefinitionHSS.createScore(4, -4, 4).multiply(1.2),
            scoreDefinitionHSS.createScore(4, -5, 4)
        )
        XCTAssertEqual(
            scoreDefinitionHSS.createScoreUninitialized(initScore: -7, scores: 4, -5, 6)
                .multiply(2.0),
            scoreDefinitionHSS.createScoreUninitialized(initScore: -14, scores: 8, -10, 12)
        )
    }

    func test_divideHSS() {
        XCTAssertEqual(
            scoreDefinitionHSS.createScore(25, -25, 25).divide(5.0),
            scoreDefinitionHSS.createScore(5, -5, 5)
        )
        XCTAssertEqual(
            scoreDefinitionHSS.createScore(21, -21, 21).divide(5.0),
            scoreDefinitionHSS.createScore(4, -5, 4)
        )
        XCTAssertEqual(
            scoreDefinitionHSS.createScore(24, -24, 24).divide(5.0),
            scoreDefinitionHSS.createScore(4, -5, 4)
        )
        XCTAssertEqual(
            scoreDefinitionHSS.createScoreUninitialized(initScore: -14, scores: 8, -10, 12)
                .divide(2.0),
            scoreDefinitionHSS.createScoreUninitialized(initScore: -7, scores: 4, -5, 6)
        )
    }

    func test_powerHSS() {
        XCTAssertEqual(
            scoreDefinitionHSS.createScore(3, -4, 5).power(2.0),
            scoreDefinitionHSS.createScore(9, 16, 25)
        )
        XCTAssertEqual(
            scoreDefinitionHSS.createScore(9, 16, 25).power(0.5),
            scoreDefinitionHSS.createScore(3, 4, 5)
        )
        XCTAssertEqual(
            scoreDefinitionHSS.createScoreUninitialized(initScore: -7, scores: 3, -4, 5).power(3.0),
            scoreDefinitionHSS.createScoreUninitialized(initScore: -343, scores: 27, -64, 125)
        )
    }

    func test_negateHSS() {
        XCTAssertEqual(
            scoreDefinitionHSS.createScore(3, -4, 5).negate(),
            scoreDefinitionHSS.createScore(-3, 4, -5)
        )
        XCTAssertEqual(
            scoreDefinitionHSS.createScore(-3, 4, -5).negate(),
            scoreDefinitionHSS.createScore(3, -4, 5)
        )
    }

    func test_absHSS() {
        XCTAssertEqual(
            scoreDefinitionHSS.createScore(3, 4, 5).abs(),
            scoreDefinitionHSS.createScore(3, 4, 5)
        )
        XCTAssertEqual(
            scoreDefinitionHSS.createScore(3, -4, 5).abs(),
            scoreDefinitionHSS.createScore(3, 4, 5)
        )
        XCTAssertEqual(
            scoreDefinitionHSS.createScore(-3, 4, -5).abs(),
            scoreDefinitionHSS.createScore(3, 4, 5)
        )
        XCTAssertEqual(
            scoreDefinitionHSS.createScore(-3, -4, -5).abs(),
            scoreDefinitionHSS.createScore(3, 4, 5)
        )
    }

    func test_zero() {
        continueAfterFailure = true // "soft assertions"
        let manualZero = BendableScore.zero(hardLevelsSize: 0, softLevelsSize: 1)
        XCTAssertEqual(manualZero.zero(), manualZero)
        XCTAssertTrue(manualZero.isZero())
        let manualOne = BendableScore.ofSoft(
            hardLevelsSize: 0,
            softLevelsSize: 1,
            softLevel: 0,
            softScore: 1
        )
        XCTAssertFalse(manualOne.isZero())
    }

    func test_equalsAndHashCodeHSS() {
        PlannerAssert.assertObjectsAreEqual(
            scoreDefinitionHSS.createScore(-10, -200, -3000),
            scoreDefinitionHSS.createScore(-10, -200, -3000),
            scoreDefinitionHSS.createScoreUninitialized(initScore: 0, scores: -10, -200, -3000)
        )
        PlannerAssert.assertObjectsAreEqual(
            scoreDefinitionHSS.createScoreUninitialized(initScore: -7, scores: -10, -200, -3000),
            scoreDefinitionHSS.createScoreUninitialized(initScore: -7, scores: -10, -200, -3000)
        )
        PlannerAssert.assertObjectsAreNotEqual(
            scoreDefinitionHSS.createScore(-10, -200, -3000),
            scoreDefinitionHSS.createScore(-30, -200, -3000),
            scoreDefinitionHSS.createScore(-10, -400, -3000),
            scoreDefinitionHSS.createScore(-10, -400, -5000),
            scoreDefinitionHSS.createScoreUninitialized(initScore: -7, scores: -10, -200, -3000)
        )
    }

    func test_compareToHSS() {
        PlannerAssert.assertCompareToOrder(
            scoreDefinitionHSS.createScoreUninitialized(initScore: -8, scores: 0, 0, 0),
            scoreDefinitionHSS.createScoreUninitialized(initScore: -7, scores: -20, -20, -20),
            scoreDefinitionHSS.createScoreUninitialized(initScore: -7, scores: -1, -300, -4000),
            scoreDefinitionHSS.createScoreUninitialized(initScore: -7, scores: 0, 0, 0),
            scoreDefinitionHSS.createScoreUninitialized(initScore: -7, scores: 0, 0, 1),
            scoreDefinitionHSS.createScoreUninitialized(initScore: -7, scores: 0, 1, 0),
            scoreDefinitionHSS.createScore(-20, Int.min, Int.min),
            scoreDefinitionHSS.createScore(-20, Int.min, -20),
            scoreDefinitionHSS.createScore(-20, Int.min, 1),
            scoreDefinitionHSS.createScore(-20, -300, -4000),
            scoreDefinitionHSS.createScore(-20, -300, -300),
            scoreDefinitionHSS.createScore(-20, -300, -20),
            scoreDefinitionHSS.createScore(-20, -300, 300),
            scoreDefinitionHSS.createScore(-20, -20, -300),
            scoreDefinitionHSS.createScore(-20, -20, 0),
            scoreDefinitionHSS.createScore(-20, -20, 1),
            scoreDefinitionHSS.createScore(-1, -300, -4000),
            scoreDefinitionHSS.createScore(-1, -300, -20),
            scoreDefinitionHSS.createScore(-1, -20, -300),
            scoreDefinitionHSS.createScore(1, Int.min, -20),
            scoreDefinitionHSS.createScore(1, -20, Int.min)
        )
    }

    private let scoreDefinitionHHSSS = BendableScoreDefinition(hardLevelsSize: 2, softLevelsSize: 3)

    func test_feasibleHHSSS() {
        Self.assertScoreNotFeasible(
            scoreDefinitionHHSSS.createScore(-1, -20, -300, -4000, -5000),
            scoreDefinitionHHSSS.createScore(-1, 0, -300, -4000, -5000),
            scoreDefinitionHHSSS.createScore(-1, 20, -300, -4000, -5000),
            scoreDefinitionHHSSS.createScore(0, -20, -300, -4000, -5000),
            scoreDefinitionHHSSS.createScore(1, -20, -300, -4000, -5000)
        )
        Self.assertScoreFeasible(
            scoreDefinitionHHSSS.createScore(0, 0, -300, -4000, -5000),
            scoreDefinitionHHSSS.createScore(0, 20, -300, -4000, -5000),
            scoreDefinitionHHSSS.createScore(1, 0, -300, -4000, -5000),
            scoreDefinitionHHSSS.createScore(1, 20, -300, -4000, -5000)
        )
    }

    func test_addHHSSS() {
        XCTAssertEqual(
            scoreDefinitionHHSSS.createScore(20, -20, -4000, 0, 0)
                .add(scoreDefinitionHHSSS.createScore(-1, -300, 4000, 0, 0)),
            scoreDefinitionHHSSS.createScore(19, -320, 0, 0, 0)
        )
    }

    func test_subtractHHSSS() {
        XCTAssertEqual(
            scoreDefinitionHHSSS.createScore(20, -20, -4000, 0, 0)
                .subtract(scoreDefinitionHHSSS.createScore(-1, -300, 4000, 0, 0)),
            scoreDefinitionHHSSS.createScore(21, 280, -8000, 0, 0)
        )
    }

    func test_multiplyHHSSS() {
        XCTAssertEqual(
            scoreDefinitionHHSSS.createScore(5, -5, 5, 0, 0).multiply(1.2),
            scoreDefinitionHHSSS.createScore(6, -6, 6, 0, 0)
        )
        XCTAssertEqual(
            scoreDefinitionHHSSS.createScore(1, -1, 1, 0, 0).multiply(1.2),
            scoreDefinitionHHSSS.createScore(1, -2, 1, 0, 0)
        )
        XCTAssertEqual(
            scoreDefinitionHHSSS.createScore(4, -4, 4, 0, 0).multiply(1.2),
            scoreDefinitionHHSSS.createScore(4, -5, 4, 0, 0)
        )
    }

    func test_divideHHSSS() {
        XCTAssertEqual(
            scoreDefinitionHHSSS.createScore(25, -25, 25, 0, 0).divide(5.0),
            scoreDefinitionHHSSS.createScore(5, -5, 5, 0, 0)
        )
        XCTAssertEqual(
            scoreDefinitionHHSSS.createScore(21, -21, 21, 0, 0).divide(5.0),
            scoreDefinitionHHSSS.createScore(4, -5, 4, 0, 0)
        )
        XCTAssertEqual(
            scoreDefinitionHHSSS.createScore(24, -24, 24, 0, 0).divide(5.0),
            scoreDefinitionHHSSS.createScore(4, -5, 4, 0, 0)
        )
    }

    func test_powerHHSSS() {
        XCTAssertEqual(
            scoreDefinitionHHSSS.createScore(3, -4, 5, 0, 0).power(2.0),
            scoreDefinitionHHSSS.createScore(9, 16, 25, 0, 0)
        )
        XCTAssertEqual(
            scoreDefinitionHHSSS.createScore(9, 16, 25, 0, 0).power(0.5),
            scoreDefinitionHHSSS.createScore(3, 4, 5, 0, 0)
        )
    }

    func test_negateHHSSS() {
        XCTAssertEqual(
            scoreDefinitionHHSSS.createScore(3, -4, 5, 0, 0).negate(),
            scoreDefinitionHHSSS.createScore(-3, 4, -5, 0, 0)
        )
        XCTAssertEqual(
            scoreDefinitionHHSSS.createScore(-3, 4, -5, 0, 0).negate(),
            scoreDefinitionHHSSS.createScore(3, -4, 5, 0, 0)
        )
    }

    func test_absHHSSS() {
        XCTAssertEqual(
            scoreDefinitionHHSSS.createScore(3, 4, 5, 0, 0).abs(),
            scoreDefinitionHHSSS.createScore(3, 4, 5, 0, 0)
        )
        XCTAssertEqual(
            scoreDefinitionHHSSS.createScore(3, -4, 5, 0, 0).abs(),
            scoreDefinitionHHSSS.createScore(3, 4, 5, 0, 0)
        )
        XCTAssertEqual(
            scoreDefinitionHHSSS.createScore(-3, 4, -5, 0, 0).abs(),
            scoreDefinitionHHSSS.createScore(3, 4, 5, 0, 0)
        )
        XCTAssertEqual(
            scoreDefinitionHHSSS.createScore(-3, -4, -5, 0, 0).abs(),
            scoreDefinitionHHSSS.createScore(3, 4, 5, 0, 0)
        )
    }

    func test_equalsAndHashCodeHHSSS() {
        PlannerAssert.assertObjectsAreEqual(
            scoreDefinitionHHSSS.createScore(-10, -20, -30, 0, 0),
            scoreDefinitionHHSSS.createScore(-10, -20, -30, 0, 0)
        )
    }

    func test_compareToHHSSS() {
        PlannerAssert.assertCompareToOrder(
            scoreDefinitionHHSSS.createScore(-20, Int.min, Int.min, 0, 0),
            scoreDefinitionHHSSS.createScore(-20, Int.min, -20, 0, 0),
            scoreDefinitionHHSSS.createScore(-20, Int.min, 1, 0, 0),
            scoreDefinitionHHSSS.createScore(-20, -300, -4000, 0, 0),
            scoreDefinitionHHSSS.createScore(-20, -300, -300, 0, 0),
            scoreDefinitionHHSSS.createScore(-20, -300, -20, 0, 0),
            scoreDefinitionHHSSS.createScore(-20, -300, 300, 0, 0),
            scoreDefinitionHHSSS.createScore(-20, -20, -300, 0, 0),
            scoreDefinitionHHSSS.createScore(-20, -20, 0, 0, 0),
            scoreDefinitionHHSSS.createScore(-20, -20, 1, 0, 0),
            scoreDefinitionHHSSS.createScore(-1, -300, -4000, 0, 0),
            scoreDefinitionHHSSS.createScore(-1, -300, -20, 0, 0),
            scoreDefinitionHHSSS.createScore(-1, -20, -300, 0, 0),
            scoreDefinitionHHSSS.createScore(1, Int.min, -20, 0, 0),
            scoreDefinitionHHSSS.createScore(1, -20, Int.min, 0, 0)
        )
    }
    
}
