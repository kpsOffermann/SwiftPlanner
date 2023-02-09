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

class HardSoftScoreDefinitionTest : XCTestCase {

    func test_getZeroScore() {
        let score = HardSoftScoreDefinition().getZeroScore()
        XCTAssertEqual(score, HardSoftScore.ZERO)
    }

    func test_getSoftestOneScore() {
        let score = HardSoftScoreDefinition().getOneSoftestScore()
        XCTAssertEqual(score, HardSoftScore.ONE_SOFT)
    }

    func test_getLevelsSize() {
        XCTAssertEqual(HardSoftScoreDefinition().getLevelsSize(), 2)
    }

    func test_getLevelLabels() {
        XCTAssertEqualIgnoringOrder(
            HardSoftScoreDefinition().getLevelLabels(),
            expected: "hard score", "soft score"
        )
    }

    func test_getFeasibleLevelsSize() {
        XCTAssertEqual(HardSoftScoreDefinition().getFeasibleLevelsSize(), 1)
    }

    func test_buildOptimisticBoundOnlyUp() {
        let scoreDefinition = HardSoftScoreDefinition()
        let optimisticBound = scoreDefinition.buildOptimisticBound(
            initializingScoreTrend: .buildUniformTrend(level: .ONLY_UP, levelsSize: 2),
            score: .of(hard: -1, soft: -2)
        )
        XCTAssertEqual(optimisticBound.initScore(), 0)
        XCTAssertEqual(optimisticBound.hardScore(), Int.max)
        XCTAssertEqual(optimisticBound.softScore(), Int.max)
    }

    func test_buildOptimisticBoundOnlyDown() {
        let scoreDefinition = HardSoftScoreDefinition()
        let optimisticBound = scoreDefinition.buildOptimisticBound(
            initializingScoreTrend: .buildUniformTrend(level: .ONLY_DOWN, levelsSize: 2),
            score: .of(hard: -1, soft: -2)
        )
        XCTAssertEqual(optimisticBound.initScore(), 0)
        XCTAssertEqual(optimisticBound.hardScore(), -1)
        XCTAssertEqual(optimisticBound.softScore(), -2)
    }

    func test_buildPessimisticBoundOnlyUp() {
        let scoreDefinition = HardSoftScoreDefinition()
        let pessimisticBound = scoreDefinition.buildPessimisticBound(
            initializingScoreTrend: .buildUniformTrend(level: .ONLY_UP, levelsSize: 2),
            score: .of(hard: -1, soft: -2)
        )
        XCTAssertEqual(pessimisticBound.initScore(), 0)
        XCTAssertEqual(pessimisticBound.hardScore(), -1)
        XCTAssertEqual(pessimisticBound.softScore(), -2)
    }

    func test_buildPessimisticBoundOnlyDown() {
        let scoreDefinition = HardSoftScoreDefinition()
        let pessimisticBound = scoreDefinition.buildPessimisticBound(
            initializingScoreTrend: .buildUniformTrend(level: .ONLY_DOWN, levelsSize: 2),
            score: .of(hard: -1, soft: -2)
        )
        XCTAssertEqual(pessimisticBound.initScore(), 0)
        XCTAssertEqual(pessimisticBound.hardScore(), Int.min)
        XCTAssertEqual(pessimisticBound.softScore(), Int.min)
    }

    func test_divideBySanitizedDivisor() {
        let scoreDefinition = HardSoftScoreDefinition()
        let dividend = scoreDefinition.fromLevelNumbers(initScore: 2, [ 0, 10 ])
        let zeroDivisor = scoreDefinition.getZeroScore()
        XCTAssertEqual(scoreDefinition.divideBySanitizedDivisor(dividend, by: zeroDivisor), dividend)
        let oneDivisor = scoreDefinition.getOneSoftestScore()
        XCTAssertEqual(scoreDefinition.divideBySanitizedDivisor(dividend, by: oneDivisor), dividend)
        let tenDivisor = scoreDefinition.fromLevelNumbers(initScore: 10, [ 10, 10 ])
        XCTAssertEqual(
            scoreDefinition.divideBySanitizedDivisor(dividend, by: tenDivisor),
            scoreDefinition.fromLevelNumbers(initScore: 0, [ 0, 1 ])
        )
    }

}
