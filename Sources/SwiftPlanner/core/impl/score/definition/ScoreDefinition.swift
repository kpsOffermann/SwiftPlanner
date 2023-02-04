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

/**
 * A ScoreDefinition knows how to compare {@link Score}s and what the perfect maximum/minimum {@link Score} is.
 *
 * @see AbstractScoreDefinition
 * @see HardSoftScoreDefinition
 * @param <Score_> the {@link Score} type
 */
public protocol ScoreDefinition : CustomStringConvertible {
    
    associatedtype Score_ : Score

    /**
     * Returns the label for {@link Score#initScore()}.
     *
     * @return never null
     * @see #getLevelLabels()
     */
    func getInitLabel() -> String

    /**
     * Returns the length of {@link Score#toLevelNumbers()} for every {@link Score} of this definition.
     * For example: returns 2 on {@link HardSoftScoreDefinition}.
     *
     * @return at least 1
     */
    func getLevelsSize() -> Int

    /**
     * Returns the number of levels of {@link Score#toLevelNumbers()}.
     * that are used to determine {@link Score#isFeasible()}.
     *
     * @return at least 0, at most {@link #getLevelsSize()}
     */
    func getFeasibleLevelsSize() -> Int

    /**
     * Returns a label for each score level. Each label includes the suffix "score" and must start in lower case.
     * For example: returns {@code {"hard score", "soft score "}} on {@link HardSoftScoreDefinition}.
     * <p>
     * It does not include the {@link #getInitLabel()}.
     *
     * @return never null, array with length of {@link #getLevelsSize()}, each element is never null
     */
    func getLevelLabels() -> [String]

    /**
     * Returns the {@link Class} of the actual {@link Score} implementation.
     * For example: returns {@link HardSoftScore HardSoftScore.class} on {@link HardSoftScoreDefinition}.
     *
     * @return never null
     */
    func getScoreClass() -> Score_.Type

    /**
     * The score that represents zero.
     *
     * @return never null
     */
    func getZeroScore() -> Score_

    /**
     * The score that represents the softest possible one.
     *
     * @return never null
     */
    func getOneSoftestScore() -> Score_

    /**
     * @param score never null
     * @return true if the score is higher or equal to {@link #getZeroScore()}
     */
    func isPositiveOrZero(_ score: Score_) -> Bool

    /**
     * @param score never null
     * @return true if the score is lower or equal to {@link #getZeroScore()}
     */
    func isNegativeOrZero(_ score: Score_) -> Bool

    /**
     * Returns a {@link String} representation of the {@link Score}.
     *
     * @param score never null
     * @return never null
     * @see #parseScore(String)
     */
    func formatScore(_ score: Score_) -> String

    /**
     * Parses the {@link String} and returns a {@link Score}.
     *
     * @param scoreString never null
     * @return never null
     * @see #formatScore(Score)
     */
    func parseScore(_ scoreString: String) -> Score_

    /**
     * The opposite of {@link Score#toLevelNumbers()}.
     *
     * @param initScore {@code <= 0}, managed by OptaPlanner, needed as a parameter in the {@link Score}'s creation
     *        method, see {@link Score#initScore()}
     * @param levelNumbers never null
     * @return never null
     */
    func fromLevelNumbers(initScore: Int, _ levelNumbers: [Number]) -> Score_

    /**
     * Builds a {@link Score} which is equal or better than any other {@link Score} with more variables initialized
     * (while the already variables don't change).
     *
     * @param initializingScoreTrend never null, with {@link InitializingScoreTrend#getLevelsSize()}
     *        equal to {@link #getLevelsSize()}.
     * @param score never null, with {@link Score#initScore()} {@code 0}.
     * @return never null
     */
    func buildOptimisticBound(initializingScoreTrend: InitializingScoreTrend, score: Score_) -> Score_

    /**
     * Builds a {@link Score} which is equal or worse than any other {@link Score} with more variables initialized
     * (while the already variables don't change).
     *
     * @param initializingScoreTrend never null, with {@link InitializingScoreTrend#getLevelsSize()}
     *        equal to {@link #getLevelsSize()}.
     * @param score never null, with {@link Score#initScore()} {@code 0}
     * @return never null
     */
    func buildPessimisticBound(initializingScoreTrend: InitializingScoreTrend, score: Score_) -> Score_

    /**
     * Return {@link Score} whose every level is the result of dividing the matching levels in this and the divisor.
     * When rounding is needed, it is floored (as defined by {@link Math#floor(double)}).
     * <p>
     * If any of the levels in the divisor are equal to zero, the method behaves as if they were equal to one instead.
     *
     * @param divisor value by which this Score is to be divided
     * @return this / divisor
     */
    func divideBySanitizedDivisor(_ dividend: Score_, by divisor: Score_) -> Score_

    /**
     * @param score never null
     * @return true if the otherScore is accepted as a parameter of {@link Score#add(Score)},
     *         {@link Score#subtract(Score)} and {@link Score#compareTo(Object)} for scores of this score definition.
     */
    func isCompatibleArithmeticArgument<S : Score>(_ score: S) -> Bool

}

// default implementations
extension ScoreDefinition {
    
    public func isPositiveOrZero(_ score: Score_) -> Bool {
        return score >= getZeroScore()
    }
    
    public func isNegativeOrZero(_ score: Score_) -> Bool {
        return score <= getZeroScore()
    }
    
}
