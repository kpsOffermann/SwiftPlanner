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

public class BendableScoreDefinition : AbstractBendableScoreDefinition<BendableScore>, ScoreDefinition {
    
    public typealias Score_ = BendableScore

    public override init(hardLevelsSize: Int, softLevelsSize: Int) {
        super.init(hardLevelsSize: hardLevelsSize, softLevelsSize: softLevelsSize)
    }

    // ************************************************************************
    // Worker methods
    // ************************************************************************

    public override func getScoreClass() -> Score_.Type {
        return BendableScore.self
    }

    public func getZeroScore() -> Score_ {
        return BendableScore.zero(hardLevelsSize: hardLevelsSize, softLevelsSize: softLevelsSize)
    }

    public func getOneSoftestScore() -> Score_ {
        return BendableScore.ofSoft(
            hardLevelsSize: hardLevelsSize,
            softLevelsSize: softLevelsSize,
            softLevel: softLevelsSize - 1,
            softScore: 1
        )
    }

    public func parseScore(_ scoreString: String) -> Score_ {
        let score = BendableScore.parseScore(scoreString)
        assert(
            score.hardLevelsSize() == hardLevelsSize,
            "The scoreString (" + scoreString + ") for the scoreClass ("
                + String(describing: BendableScore.self) + ") doesn't follow the correct pattern:"
                + " the hardLevelsSize (" + score.hardLevelsSize()
                + ") doesn't match the scoreDefinition's hardLevelsSize (" + hardLevelsSize + ")."
        )
        assert(
            score.softLevelsSize() == softLevelsSize,
            "The scoreString (" + scoreString + ") for the scoreClass ("
                + String(describing: BendableScore.self) + ") doesn't follow the correct pattern:"
                + " the softLevelsSize (" + score.softLevelsSize()
                + ") doesn't match the scoreDefinition's softLevelsSize (" + softLevelsSize + ")."
        )
        return score
    }

    public func fromLevelNumbers(initScore: Int, _ levelNumbers: [Number]) -> Score_ {
        assert(
            levelNumbers.count == getLevelsSize(),
            "The levelNumbers (" + levelNumbers + ")'s length (" + levelNumbers.count
                + ") must equal the levelSize (" + getLevelsSize() + ")."
        )
        return .ofUninitialized(
            init: initScore,
            hards: levelNumbers[to: hardLevelsSize].map({ $0.toInt() }),
            softs: levelNumbers[from: hardLevelsSize, count: softLevelsSize].map({ $0.toInt() })
        )
    }

    public func createScore(_ scores: Int...) -> BendableScore {
        createScore(scores)
    }
    
    public func createScore(_ scores: [Int]) -> BendableScore {
        return createScoreUninitialized(initScore: 0, scores: scores)
    }

    public func createScoreUninitialized(initScore: Int, scores: Int...) -> BendableScore {
        createScoreUninitialized(initScore: initScore, scores: scores)
    }
    
    public func createScoreUninitialized(initScore: Int, scores: [Int]) -> BendableScore {
        let levelsSize = hardLevelsSize + softLevelsSize
        assert(
            scores.count == levelsSize,
            "The scores (" + scores + ")'s length (" + scores.count
                + ") is not levelsSize (" + levelsSize + ")."
        )
        return .ofUninitialized(
            init: initScore,
            hards: scores[to: hardLevelsSize],
            softs: scores[hardLevelsSize, levelsSize]
        )
    }

    public func buildOptimisticBound(
            initializingScoreTrend: InitializingScoreTrend,
            score: Score_
    ) -> Score_ {
        let trendLevels = initializingScoreTrend.getTrendLevels()
        let hardScores = trendLevels[to: hardLevelsSize].enumerated().map({ index, level in
            level == .ONLY_DOWN ? score.hardScore(level: index) : Int.max
        })
        let softScores = trendLevels[from: hardLevelsSize, count: softLevelsSize].enumerated()
            .map({ index, level in
                level == .ONLY_DOWN ? score.softScore(level: index) : Int.max
            })
        return .ofUninitialized(init: 0, hards: hardScores, softs: softScores)
    }

    public func buildPessimisticBound(
            initializingScoreTrend: InitializingScoreTrend,
            score: Score_
    ) -> Score_ {
        let trendLevels = initializingScoreTrend.getTrendLevels()
        let hardScores = trendLevels[to: hardLevelsSize].enumerated().map({ index, level in
            level == .ONLY_UP ? score.hardScore(level: index) : Int.min
        })
        let softScores = trendLevels[from: hardLevelsSize, count: softLevelsSize].enumerated()
            .map({ index, level in
                level == .ONLY_UP ? score.softScore(level: index) : Int.min
            })
        return .ofUninitialized(init: 0, hards: hardScores, softs: softScores)
    }

    public func divideBySanitizedDivisor(_ dividend: Score_, by divisor: Score_) -> Score_ {
        let sanitizedDivide: (Int, Int) -> (Int) = { Self.divide($0, by: Self.sanitize($1)) }
        let hardScores = zip(dividend.hardScores(), divisor.hardScores()).map(sanitizedDivide)
        let softScores = zip(dividend.softScores(), divisor.softScores()).map(sanitizedDivide)
        return createScoreUninitialized(
            initScore: sanitizedDivide(dividend.initScore(), divisor.initScore()),
            scores: hardScores + softScores
        )
    }
    
}
