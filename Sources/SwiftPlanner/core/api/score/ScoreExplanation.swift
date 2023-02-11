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
 * Build by {@link ScoreManager#explainScore(Object)} to hold {@link ConstraintMatchTotal}s and {@link Indictment}s
 * necessary to explain the quality of a particular {@link Score}.
 *
 * @param <Solution_> the solution type, the class with the {@link PlanningSolution} annotation
 * @param <Score_> the actual score type
 */
public protocol ScoreExplanation<Solution_, Score_> {
    
    associatedtype Solution_
    
    associatedtype Score_ : Score

    /**
     * Retrieve the {@link PlanningSolution} that the score being explained comes from.
     *
     * @return never null
     */
    func getSolution() -> Solution_

    /**
     * Return the {@link Score} being explained.
     * If the specific {@link Score} type used by the {@link PlanningSolution} is required,
     * call {@link #getSolution()} and retrieve it from there.
     *
     * @return never null
     */
    func getScore() -> Score_

    /**
     * Returns a diagnostic text that explains the {@link Score} through the {@link ConstraintMatch} API
     * to identify which constraints or planning entities cause that score quality.
     * In case of an {@link Score#isFeasible() infeasible} solution,
     * this can help diagnose the cause of that.
     * <p>
     * Do not parse this string.
     * Instead, to provide this information in a UI or a service,
     * use {@link #getConstraintMatchTotalMap()} and {@link #getIndictmentMap()}
     * and convert those into a domain specific API.
     *
     * @return never null
     */
    func getSummary() -> String

    /**
     * Explains the {@link Score} of {@link #getScore()} by splitting it up per {@link Constraint}.
     * <p>
     * The sum of {@link ConstraintMatchTotal#getScore()} equals {@link #getScore()}.
     *
     * @return never null, the key is the {@link ConstraintMatchTotal#getConstraintId() constraintId}
     *         (to create one, use {@link ConstraintMatchTotal#composeConstraintId(String, String)}).
     * @see #getIndictmentMap()
     */
    @available(macOS 13.0.0, *)
    func getConstraintMatchTotalMap() -> [String:any ConstraintMatchTotal<Score_>]

    /**
     * Explains the {@link Score} of {@link #getScore()} for all constraints.
     * The return value of this method is determined by several factors:
     *
     * <ul>
     * <li>
     * With Constraint Streams, the user has an option to provide a custom justification mapping,
     * implementing {@link ConstraintJustification}.
     * If provided, every {@link ConstraintMatch} of such constraint will be associated with this custom justification class.
     * Every constraint not associated with a custom justification class
     * will be associated with {@link DefaultConstraintJustification}.
     * </li>
     * <li>
     * With {@link ConstraintMatchAwareIncrementalScoreCalculator},
     * every {@link ConstraintMatch} will be associated with the justification class that the user created it with.
     * </li>
     * <li>
     * With score DRL, every {@link ConstraintMatch} will be associated with {@link DefaultConstraintJustification}.
     * </li>
     * </ul>
     *
     * @return never null, all constraint matches
     * @see #getIndictmentMap()
     */
    func getJustificationList() -> [ConstraintJustification]

    /**
     * Explains the {@link Score} of {@link #getScore()} for all constraints
     * justified with a given {@link ConstraintJustification} type.
     * Otherwise, as defined by {@link #getJustificationList()}.
     *
     * @param constraintJustificationClass never null
     * @return never null, all constraint matches associated with the given justification class
     * @see #getIndictmentMap()
     */
    func getJustificationList<ConstraintJustification_ : ConstraintJustification>(
            constraintJustificationClass: ConstraintJustification_.Type
    ) -> [ConstraintJustification_]

    /**
     * Explains the impact of each planning entity or problem fact on the {@link Score}.
     * An {@link Indictment} is basically the inverse of a {@link ConstraintMatchTotal}:
     * it is a {@link Score} total for any of the {@link ConstraintMatch#getIndictedObjectList() indicted objects}.
     * <p>
     * The sum of {@link ConstraintMatchTotal#getScore()} differs from {@link #getScore()}
     * because each {@link ConstraintMatch#getScore()} is counted
     * for each of the {@link ConstraintMatch#getIndictedObjectList() indicted objects}.
     *
     * @return never null, the key is a {@link ProblemFactCollectionProperty problem fact} or a
     *         {@link PlanningEntity planning entity}
     * @see #getConstraintMatchTotalMap()
     */
    @available(macOS 13.0.0, *)
    func getIndictmentMap() -> [AnyHashable:any Indictment<Score_>]

}

// default implementations
extension ScoreExplanation {
    
    func getJustificationList<ConstraintJustification_ : ConstraintJustification>(
            constraintJustificationClass: ConstraintJustification_.Type
    ) -> [ConstraintJustification_] {
        return getJustificationList().compactMap({ $0 as? ConstraintJustification_ })
    }
    
}
