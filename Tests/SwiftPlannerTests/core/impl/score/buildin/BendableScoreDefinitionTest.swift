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

// WIP: expected fail test: test_createScoreWithIllegalArgument

import XCTest
@testable import SwiftPlanner

class BendableScoreDefinitionTest : XCTestCase {

    func test_getZeroScore() {
        let score = BendableScoreDefinition(hardLevelsSize: 1, softLevelsSize: 2).getZeroScore()
        XCTAssertEqual(score, BendableScore.zero(hardLevelsSize: 1, softLevelsSize: 2))
    }

    func test_getSoftestOneScore() {
        let score = BendableScoreDefinition(hardLevelsSize: 1, softLevelsSize: 2).getOneSoftestScore()
        XCTAssertEqual(score, BendableScore.of(hards: [0], softs: [0, 1]))
    }

    func test_getLevelsSize() {
        XCTAssertEqual(BendableScoreDefinition(hardLevelsSize: 1, softLevelsSize: 1).getLevelsSize(), 2)
        XCTAssertEqual(BendableScoreDefinition(hardLevelsSize: 3, softLevelsSize: 4).getLevelsSize(), 7)
        XCTAssertEqual(BendableScoreDefinition(hardLevelsSize: 4, softLevelsSize: 3).getLevelsSize(), 7)
        XCTAssertEqual(BendableScoreDefinition(hardLevelsSize: 0, softLevelsSize: 5).getLevelsSize(), 5)
        XCTAssertEqual(BendableScoreDefinition(hardLevelsSize: 5, softLevelsSize: 0).getLevelsSize(), 5)
    }

    func test_getLevelLabels() {
        XCTAssertEqualIgnoringOrder(
            BendableScoreDefinition(hardLevelsSize: 1, softLevelsSize: 1).getLevelLabels(),
            expected: "hard 0 score", "soft 0 score"
        )
        XCTAssertEqualIgnoringOrder(
            BendableScoreDefinition(hardLevelsSize: 3, softLevelsSize: 4).getLevelLabels(),
            expected: "hard 0 score", "hard 1 score", "hard 2 score",
                "soft 0 score", "soft 1 score", "soft 2 score", "soft 3 score"
        )
        XCTAssertEqualIgnoringOrder(
            BendableScoreDefinition(hardLevelsSize: 4, softLevelsSize: 3).getLevelLabels(),
            expected: "hard 0 score", "hard 1 score", "hard 2 score", "hard 3 score",
                "soft 0 score", "soft 1 score", "soft 2 score"
        )
        XCTAssertEqualIgnoringOrder(
            BendableScoreDefinition(hardLevelsSize: 0, softLevelsSize: 5).getLevelLabels(),
            expected: "soft 0 score", "soft 1 score", "soft 2 score", "soft 3 score", "soft 4 score"
        )
        XCTAssertEqualIgnoringOrder(
            BendableScoreDefinition(hardLevelsSize: 5, softLevelsSize: 0).getLevelLabels(),
            expected: "hard 0 score", "hard 1 score", "hard 2 score", "hard 3 score", "hard 4 score"
        )
    }

    func test_getFeasibleLevelsSize() {
        XCTAssertEqual(BendableScoreDefinition(hardLevelsSize: 1, softLevelsSize: 1).getFeasibleLevelsSize(), 1)
        XCTAssertEqual(BendableScoreDefinition(hardLevelsSize: 3, softLevelsSize: 4).getFeasibleLevelsSize(), 3)
        XCTAssertEqual(BendableScoreDefinition(hardLevelsSize: 4, softLevelsSize: 3).getFeasibleLevelsSize(), 4)
        XCTAssertEqual(BendableScoreDefinition(hardLevelsSize: 0, softLevelsSize: 5).getFeasibleLevelsSize(), 0)
        XCTAssertEqual(BendableScoreDefinition(hardLevelsSize: 5, softLevelsSize: 0).getFeasibleLevelsSize(), 5)
    }
    /*
    func test_createScoreWithIllegalArgument() {
        XCTExpectFailure("assert fail is expected")
        let bendableScoreDefinition = BendableScoreDefinition(2, 3)
        //assertThatIllegalArgumentException().isThrownBy(() -> bendableScoreDefinition.createScore(1, 2, 3));
    }
     */
    func test_createScore() {
        let hardLevelSize = 3
        let softLevelSize = 2
        let levelSize = hardLevelSize + softLevelSize
        let scores = Array(0..<levelSize)
        let bendableScoreDefinition = BendableScoreDefinition(
            hardLevelsSize: hardLevelSize,
            softLevelsSize: softLevelSize
        )
        let bendableScore = bendableScoreDefinition.createScore(scores)
        XCTAssertEqual(bendableScore.hardLevelsSize(), hardLevelSize)
        XCTAssertEqual(bendableScore.softLevelsSize(), softLevelSize)
        for i in 0..<levelSize {
            if (i < hardLevelSize) {
                XCTAssertEqual(bendableScore.hardScore(level: i), scores[i])
            } else {
                XCTAssertEqual(bendableScore.softScore(level: i - hardLevelSize), scores[i])
            }
        }
    }

    func test_buildOptimisticBoundOnlyUp() {
        let scoreDefinition = BendableScoreDefinition(hardLevelsSize: 2, softLevelsSize: 3)
        let optimisticBound = scoreDefinition.buildOptimisticBound(
            initializingScoreTrend: .buildUniformTrend(level: .ONLY_UP, levelsSize: 5),
            score: scoreDefinition.createScore(-1, -2, -3, -4, -5)
        )
        XCTAssertEqual(optimisticBound.initScore(), 0);
        XCTAssertEqual(optimisticBound.hardScore(level: 0), Int.max)
        XCTAssertEqual(optimisticBound.hardScore(level: 1), Int.max)
        XCTAssertEqual(optimisticBound.softScore(level: 0), Int.max)
        XCTAssertEqual(optimisticBound.softScore(level: 1), Int.max)
        XCTAssertEqual(optimisticBound.softScore(level: 2), Int.max)
    }

    func test_buildOptimisticBoundOnlyDown() {
        let scoreDefinition = BendableScoreDefinition(hardLevelsSize: 2, softLevelsSize: 3)
        let optimisticBound = scoreDefinition.buildOptimisticBound(
            initializingScoreTrend: .buildUniformTrend(level: .ONLY_DOWN, levelsSize: 5),
            score: scoreDefinition.createScore(-1, -2, -3, -4, -5)
        )
        XCTAssertEqual(optimisticBound.initScore(), 0)
        XCTAssertEqual(optimisticBound.hardScore(level: 0), -1)
        XCTAssertEqual(optimisticBound.hardScore(level: 1), -2)
        XCTAssertEqual(optimisticBound.softScore(level: 0), -3)
        XCTAssertEqual(optimisticBound.softScore(level: 1), -4)
        XCTAssertEqual(optimisticBound.softScore(level: 2), -5)
    }

    func test_buildPessimisticBoundOnlyUp() {
        let scoreDefinition = BendableScoreDefinition(hardLevelsSize: 2, softLevelsSize: 3)
        let pessimisticBound = scoreDefinition.buildPessimisticBound(
            initializingScoreTrend: .buildUniformTrend(level: .ONLY_UP, levelsSize: 5),
            score: scoreDefinition.createScore(-1, -2, -3, -4, -5)
        )
        XCTAssertEqual(pessimisticBound.initScore(), 0)
        XCTAssertEqual(pessimisticBound.hardScore(level: 0), -1)
        XCTAssertEqual(pessimisticBound.hardScore(level: 1), -2)
        XCTAssertEqual(pessimisticBound.softScore(level: 0), -3)
        XCTAssertEqual(pessimisticBound.softScore(level: 1), -4)
        XCTAssertEqual(pessimisticBound.softScore(level: 2), -5)
    }

    func test_buildPessimisticBoundOnlyDown() {
        let scoreDefinition = BendableScoreDefinition(hardLevelsSize: 2, softLevelsSize: 3)
        let pessimisticBound = scoreDefinition.buildPessimisticBound(
            initializingScoreTrend: .buildUniformTrend(level: .ONLY_DOWN, levelsSize: 5),
            score: scoreDefinition.createScore(-1, -2, -3, -4, -5)
        )
        XCTAssertEqual(pessimisticBound.initScore(), 0)
        XCTAssertEqual(pessimisticBound.hardScore(level: 0), Int.min)
        XCTAssertEqual(pessimisticBound.hardScore(level: 1), Int.min)
        XCTAssertEqual(pessimisticBound.softScore(level: 0), Int.min)
        XCTAssertEqual(pessimisticBound.softScore(level: 1), Int.min)
        XCTAssertEqual(pessimisticBound.softScore(level: 2), Int.min)
    }

    func test_divideBySanitizedDivisor() {
        let scoreDefinition = BendableScoreDefinition(hardLevelsSize: 1, softLevelsSize: 1)
        let dividend = scoreDefinition.createScoreUninitialized(initScore: 2, scores: 0, 10)
        let zeroDivisor = scoreDefinition.getZeroScore()
        XCTAssertEqual(scoreDefinition.divideBySanitizedDivisor(dividend, by: zeroDivisor), dividend)
        let oneDivisor = scoreDefinition.getOneSoftestScore()
        XCTAssertEqual(scoreDefinition.divideBySanitizedDivisor(dividend, by: oneDivisor), dividend)
        let tenDivisor = scoreDefinition.createScoreUninitialized(initScore: 10, scores: 10, 10)
        XCTAssertEqual(
            scoreDefinition.divideBySanitizedDivisor(dividend, by: tenDivisor),
            scoreDefinition.createScoreUninitialized(initScore: 0, scores: 0, 1)
        )
    }

}
