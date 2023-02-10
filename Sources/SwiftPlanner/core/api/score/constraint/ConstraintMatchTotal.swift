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
 * Explains the {@link Score} of a {@link PlanningSolution}, from the opposite side than {@link Indictment}.
 * Retrievable from {@link ScoreExplanation#getConstraintMatchTotalMap()}.
 *
 * @param <Score_> the actual score type
 */
public protocol ConstraintMatchTotal<Score_> {
    
    associatedtype Score_ : Score

    /**
     * @return never null
     */
    func getConstraintPackage() -> String

    /**
     * @return never null
     */
    func getConstraintName() -> String

    /**
     * The value of the {@link ConstraintWeight} annotated member of the {@link ConstraintConfiguration}.
     * It's independent to the state of the {@link PlanningVariable planning variables}.
     * Do not confuse with {@link #getScore()}.
     *
     * @return null if {@link ConstraintWeight} isn't used for this constraint
     */
    func getConstraintWeight() -> Score_?

    /**
     * @return never null
     */
    func getConstraintMatchSet() -> Set<ConstraintMatch<Score_>>

    /**
     * @return {@code >= 0}
     */
    func getConstraintMatchCount() -> Int

    /**
     * Sum of the {@link #getConstraintMatchSet()}'s {@link ConstraintMatch#getScore()}.
     *
     * @return never null
     */
    func getScore() -> Score_

    /**
     * To create a constraintId, use {@link #composeConstraintId(String, String)}.
     *
     * @return never null
     */
    func getConstraintId() -> String

}

extension ConstraintMatchTotal {
    
    public func getConstraintMatchCount() -> Int {
        return getConstraintMatchSet().count
    }
    
}
