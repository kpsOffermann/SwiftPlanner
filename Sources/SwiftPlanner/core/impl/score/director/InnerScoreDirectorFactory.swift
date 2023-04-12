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
 * @param <Solution_> the solution type, the class with the {@link PlanningSolution} annotation
 * @param <Score_> the score type to go with the solution
 */
public protocol InnerScoreDirectorFactory<Solution_, Score_> : ScoreDirectorFactory {
    
    associatedtype Score_ : Score

    /**
     * @return never null
     */
    func getSolutionDescriptor() -> SolutionDescriptor<Solution_, Score_>

    /**
     * @return never null
     */
    func getScoreDefinition() -> any ScoreDefinition<Score_>

    func buildScoreDirector() -> any InnerScoreDirector<Solution_, Score_>

    /**
     * Like {@link #buildScoreDirector()}, but optionally disables {@link ConstraintMatch} tracking and look up
     * for more performance (presuming the {@link ScoreDirector} implementation actually supports it to begin with).
     *
     * @param lookUpEnabled true if a {@link ScoreDirector} implementation should track all working objects
     *        for {@link ScoreDirector#lookUpWorkingObject(Object)}
     * @param constraintMatchEnabledPreference false if a {@link ScoreDirector} implementation
     *        should not do {@link ConstraintMatch} tracking even if it supports it.
     * @return never null
     * @see InnerScoreDirector#isConstraintMatchEnabled()
     * @see InnerScoreDirector#getConstraintMatchTotalMap()
     */
    func buildScoreDirector(
            lookUpEnabled: Bool,
            constraintMatchEnabledPreference: Bool
    ) -> any InnerScoreDirector<Solution_, Score_>

    /**
     * @return never null
     */
    func getInitializingScoreTrend() -> InitializingScoreTrend

    /**
     * Asserts that if the {@link Score} is calculated for the parameter solution,
     * it would be equal to the score of that parameter.
     *
     * @param solution never null
     * @see InnerScoreDirector#assertWorkingScoreFromScratch(Score, Object)
     */
    func assertScoreFromScratch(solution: Solution_)

}
