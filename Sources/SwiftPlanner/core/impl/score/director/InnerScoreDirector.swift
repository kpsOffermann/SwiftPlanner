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

// WIP: requires VariableDescriptor, ListVariableDescriptor for part II
// WIP: Features of AutoCloseable

/**
 * @param <Solution_> the solution type, the class with the {@link PlanningSolution} annotation
 * @param <Score_> the score type to go with the solution
 */
public protocol InnerScoreDirector<Solution_, Score_> : ScoreDirector/*, AutoCloseable*/ {

    associatedtype Score_ : Score
    
    /**
     * The {@link PlanningSolution working solution} must never be the same instance as the
     * {@link PlanningSolution best solution}, it should be a (un)changed clone.
     *
     * @param workingSolution never null
     */
    func setWorkingSolution(_ workingSolution: Solution_)

    /**
     * Calculates the {@link Score} and updates the {@link PlanningSolution working solution} accordingly.
     *
     * @return never null, the {@link Score} of the {@link PlanningSolution working solution}
     */
    func calculateScore() -> Score_

    /**
     * @return true if {@link #getConstraintMatchTotalMap()} and {@link #getIndictmentMap} can be called
     */
    func isConstraintMatchEnabled() -> Bool

    /**
     * Explains the {@link Score} of {@link #calculateScore()} by splitting it up per {@link Constraint}.
     * <p>
     * The sum of {@link ConstraintMatchTotal#getScore()} equals {@link #calculateScore()}.
     * <p>
     * Call {@link #calculateScore()} before calling this method,
     * unless that method has already been called since the last {@link PlanningVariable} changes.
     *
     * @return never null, the key is the {@link ConstraintMatchTotal#getConstraintId() constraintId}
     *         (to create one, use {@link ConstraintMatchTotal#composeConstraintId(String, String)}).
     * @throws IllegalStateException if {@link #isConstraintMatchEnabled()} returns false
     * @see #getIndictmentMap()
     */
    @available(macOS 13.0.0, *)
    func getConstraintMatchTotalMap() -> [String:any ConstraintMatchTotal<Score_>]

    /**
     * Explains the impact of each planning entity or problem fact on the {@link Score}.
     * An {@link Indictment} is basically the inverse of a {@link ConstraintMatchTotal}:
     * it is a {@link Score} total for each {@link ConstraintMatch#getJustification() constraint justification}.
     * <p>
     * The sum of {@link ConstraintMatchTotal#getScore()} differs from {@link #calculateScore()}
     * because each {@link ConstraintMatch#getScore()} is counted
     * for each {@link ConstraintMatch#getJustification() constraint justification}.
     * <p>
     * Call {@link #calculateScore()} before calling this method,
     * unless that method has already been called since the last {@link PlanningVariable} changes.
     *
     * @return never null, the key is a {@link ProblemFactCollectionProperty problem fact} or a
     *         {@link PlanningEntity planning entity}
     * @throws IllegalStateException if {@link #isConstraintMatchEnabled()} returns false
     * @see #getConstraintMatchTotalMap()
     */
    @available(macOS 13.0.0, *)
    func getIndictmentMap() -> [AnyHashable:any Indictment<Score_>]

    /**
     * @param constraintMatchEnabledPreference false if a {@link ScoreDirector} implementation
     *        should not do {@link ConstraintMatch} tracking even if it supports it.
     */
    func overwriteConstraintMatchEnabledPreference(_ constraintMatchEnabledPreference: Bool)

    /**
     * @return used to check {@link #isWorkingEntityListDirty(long)} later on
     */
    func getWorkingEntityListRevision() -> Int64

    /**
     * @param move never null
     * @param assertMoveScoreFromScratch true will hurt performance
     * @return never null
     */
    func doAndProcessMove(_ move: any Move<Solution_>, assertMoveScoreFromScratch: Bool) -> Score_

    /**
     * @param move never null
     * @param assertMoveScoreFromScratch true will hurt performance
     * @param moveProcessor never null, use this to store the score as well as call the acceptor and forager
     */
    func doAndProcessMove(
            _ move: any Move<Solution_>,
            assertMoveScoreFromScratch: Bool,
            moveProcessor: (Score_) -> Void
    )

    /**
     * @param expectedWorkingEntityListRevision an
     * @return true if the entityList might have a different set of instances now
     */
    func isWorkingEntityListDirty(expectedRevision expectedWorkingEntityListRevision: Int64) -> Bool

    /**
     * Some score directors (such as the Drools-based) keep a set of changes
     * that they only apply when {@link #calculateScore()} is called.
     * Until that happens, this set accumulates and could possibly act as a memory leak.
     *
     * @return true if the score director can potentially cause a memory leak due to unflushed changes.
     */
    func requiresFlushing() -> Bool

    /**
     * @return never null
     */
    func getScoreDirectorFactory() -> any InnerScoreDirectorFactory<Solution_, Score_>
    
    /**
     * @return never null
     */
    func getSolutionDescriptor() -> SolutionDescriptor<Solution_, Score_>

    /**
     * @return never null
     */
    func getScoreDefinition() -> any ScoreDefinition<Score_>

    /**
     * Returns a planning clone of the solution,
     * which is not a shallow clone nor a deep clone nor a partition clone.
     *
     * @return never null, planning clone
     */
    func cloneWorkingSolution() -> Solution_

    /**
     * Returns a planning clone of the solution,
     * which is not a shallow clone nor a deep clone nor a partition clone.
     *
     * @param originalSolution never null
     * @return never null, planning clone
     */
    func cloneSolution(_ originalSolution: Solution_) -> Solution_

    /**
     * @return at least 0L
     */
    func getCalculationCount() -> UInt64

    func resetCalculationCount()

    /**
     * @return never null
     */
    func getSupplyManager() -> SupplyManager

    /**
     * Clones this {@link ScoreDirector} and its {@link PlanningSolution working solution}.
     * Use {@link #getWorkingSolution()} to retrieve the {@link PlanningSolution working solution} of that clone.
     * <p>
     * This is heavy method, because it usually breaks incremental score calculation. Use it sparingly.
     * Therefore it's best to clone lazily by delaying the clone call as long as possible.
     *
     * @return never null
     */
    func clone() -> Self // any InnerScoreDirector<Solution_, Score_>

    func createChildThreadScoreDirector(
            type childThreadType: ChildThreadType
    ) -> any InnerScoreDirector<Solution_, Score_>

    /**
     * Do not waste performance by propagating changes to step (or higher) mechanisms.
     *
     * @param allChangesWillBeUndoneBeforeStepEnds true if all changes will be undone
     */
    func setAllChangesWillBeUndoneBeforeStepEnds(_ allChangesWillBeUndoneBeforeStepEnds: Bool)

    /**
     * Asserts that if the {@link Score} is calculated for the current {@link PlanningSolution working solution}
     * in the current {@link ScoreDirector} (with possibly incremental calculation residue),
     * it is equal to the parameter {@link Score expectedWorkingScore}.
     * <p>
     * Used to assert that skipping {@link #calculateScore()} (when the score is otherwise determined) is correct.
     *
     * @param expectedWorkingScore never null
     * @param completedAction sometimes null, when assertion fails then the completedAction's {@link Object#toString()}
     *        is included in the exception message
     */
    func assertExpectedWorkingScore(
            _ expectedWorkingScore: Score_,
            completedAction: CustomStringConvertible?
    )

    /**
     * Asserts that if all {@link VariableListener}s are forcibly triggered,
     * and therefore all shadow variables are updated if needed,
     * that none of the shadow variables of the {@link PlanningSolution working solution} change,
     * Then also asserts that the {@link Score} calculated for the {@link PlanningSolution working solution} afterwards
     * is equal to the parameter {@link Score expectedWorkingScore}.
     * <p>
     * Used to assert that the shadow variables' state is consistent with the genuine variables' state.
     *
     * @param expectedWorkingScore never null
     * @param completedAction sometimes null, when assertion fails then the completedAction's {@link Object#toString()}
     *        is included in the exception message
     */
    func assertShadowVariablesAreNotStale(
            expectedWorkingScore: Score_,
            completedAction: CustomStringConvertible?
    )

    /**
     * Asserts that if the {@link Score} is calculated for the current {@link PlanningSolution working solution}
     * in a fresh {@link ScoreDirector} (with no incremental calculation residue),
     * it is equal to the parameter {@link Score workingScore}.
     * <p>
     * Furthermore, if the assert fails, a score corruption analysis might be included in the exception message.
     *
     * @param workingScore never null
     * @param completedAction sometimes null, when assertion fails then the completedAction's {@link Object#toString()}
     *        is included in the exception message
     * @see InnerScoreDirectorFactory#assertScoreFromScratch
     */
    func assertWorkingScoreFromScratch(
            _ workingScore: Score_,
            completedAction: CustomStringConvertible?
    )

    /**
     * Asserts that if the {@link Score} is calculated for the current {@link PlanningSolution working solution}
     * in a fresh {@link ScoreDirector} (with no incremental calculation residue),
     * it is equal to the parameter {@link Score predictedScore}.
     * <p>
     * Furthermore, if the assert fails, a score corruption analysis might be included in the exception message.
     *
     * @param predictedScore never null
     * @param completedAction sometimes null, when assertion fails then the completedAction's {@link Object#toString()}
     *        is included in the exception message
     * @see InnerScoreDirectorFactory#assertScoreFromScratch
     */
    func assertPredictedScoreFromScratch(
            _ predictedScore: Score_,
            completedAction: CustomStringConvertible?
    )

    /**
     * Asserts that if the {@link Score} is calculated for the current {@link PlanningSolution working solution}
     * in the current {@link ScoreDirector} (with incremental calculation residue),
     * it is equal to the parameter {@link Score beforeMoveScore}.
     * <p>
     * Furthermore, if the assert fails, a score corruption analysis might be included in the exception message.
     *
     * @param move never null
     * @param beforeMoveScore never null
     */
    func assertExpectedUndoMoveScore(move: any Move<Solution_>, beforeMoveScore: Score_)

    /**
     * Asserts that none of the planning facts from {@link SolutionDescriptor#getAllFacts(Object)} for
     * {@link #getWorkingSolution()} have {@link PlanningId}s with a null value.
     */
    func assertNonNullPlanningIds()

    /**
     * Needs to be called after use because some implementations need to clean up their resources.
     */
    func close()
            
    // WIP: part II

}
