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

public class HardSoftScoreDefinition : AbstractScoreDefinition<HardSoftScore>, ScoreDefinition {

    public typealias Score_ = HardSoftScore
    
    public init() {
        super.init(levelLabels: [ "hard score", "soft score" ])
    }

    // ************************************************************************
    // Worker methods
    // ************************************************************************

    public func getFeasibleLevelsSize() -> Int {
        return 1
    }

    public override func getScoreClass() -> Score_.Type {
        return HardSoftScore.self
    }

    public func getZeroScore() -> Score_ {
        return HardSoftScore.ZERO
    }

    public func getOneSoftestScore() -> Score_ {
        return HardSoftScore.ONE_SOFT
    }

    public func parseScore(_ scoreString: String) -> Score_ {
        return HardSoftScore.parseScore(scoreString)
    }

    public func fromLevelNumbers(initScore: Int, _ levelNumbers: [Number]) -> Score_ {
        guard levelNumbers.count == getLevelsSize() else {
            return assertionFailure(
                "The levelNumbers (" + levelNumbers + ")'s length (" + levelNumbers.count
                    + ") must equal the levelSize (" + getLevelsSize() + ")."
            )
        }
        return HardSoftScore.ofUninitialized(
            init: initScore,
            hard: levelNumbers[0].toInt(),
            soft: levelNumbers[1].toInt()
        )
    }

    public func buildOptimisticBound(
            initializingScoreTrend: InitializingScoreTrend,
            score: Score_
    ) -> Score_ {
        let trendLevels = initializingScoreTrend.getTrendLevels();
        return HardSoftScore.ofUninitialized(
            init: 0,
            hard: trendLevels[0] == .ONLY_DOWN ? score.hardScore() : Int.max,
            soft: trendLevels[1] == .ONLY_DOWN ? score.softScore() : Int.max
        )
    }

    public func buildPessimisticBound(
            initializingScoreTrend: InitializingScoreTrend,
            score: Score_
    ) -> Score_ {
        let trendLevels = initializingScoreTrend.getTrendLevels();
        return HardSoftScore.ofUninitialized(
            init: 0,
            hard: trendLevels[0] == .ONLY_UP ? score.hardScore() : Int.min,
            soft: trendLevels[1] == .ONLY_UP ? score.softScore() : Int.min
        )
    }

    public func divideBySanitizedDivisor(
            _ dividend: Score_,
            by divisor: Score_
    ) -> Score_ {
        let sanitizedDivide: (Int, Int) -> (Int) = { Self.divide($0, by: Self.sanitize($1)) }
        return fromLevelNumbers(
            initScore: sanitizedDivide(dividend.initScore(), divisor.initScore()),
            [
                sanitizedDivide(dividend.hardScore(), divisor.hardScore()),
                sanitizedDivide(dividend.softScore(), divisor.softScore())
            ]
        )
    }
    
}
