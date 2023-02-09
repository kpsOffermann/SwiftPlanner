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
 * Explains the {@link Score} of a {@link PlanningSolution}, from the opposite side than {@link ConstraintMatchTotal}.
 * Retrievable from {@link ScoreExplanation#getIndictmentMap()}.
 *
 * @param <Score_> the actual score type
 */
public protocol Indictment<Score_> {

    associatedtype Score_ : Score

    /**
     * The object that was involved in causing the constraints to match.
     * It is part of {@link ConstraintMatch#getIndictedObjectList()} of every {@link ConstraintMatch}
     * returned by {@link #getConstraintMatchSet()}.
     *
     * @return never null
     * @param <IndictedObject_> Shorthand so that the user does not need to cast in user code.
     */
    func getIndictedObject() -> CustomStringConvertible

    /**
     * @return never null
     */
    func getConstraintMatchSet() -> Set<ConstraintMatch<Score_>>

    /**
     * @return {@code >= 0}
     */
    func getConstraintMatchCount() -> Int

    /**
     * Retrieve {@link ConstraintJustification} instances associated with {@link ConstraintMatch}es in
     * {@link #getConstraintMatchSet()}.
     * This is equivalent to retrieving {@link #getConstraintMatchSet()}
     * and collecting all {@link ConstraintMatch#getJustification()} objects into a list.
     *
     * @return never null, guaranteed to contain unique instances
     */
    func getJustificationList() -> [ConstraintJustification]

    /**
     * Retrieve {@link ConstraintJustification} instances associated with {@link ConstraintMatch}es in
     * {@link #getConstraintMatchSet()}, which are of (or extend) a given constraint justification implementation.
     * This is equivalent to retrieving {@link #getConstraintMatchSet()}
     * and collecting all matching {@link ConstraintMatch#getJustification()} objects into a list.
     *
     * @return never null, guaranteed to contain unique instances
     */
    func getJustificationList<ConstraintJustification_ : ConstraintJustification>(
            justificationClass: ConstraintJustification_.Type
    ) -> [ConstraintJustification_]

    /**
     * Sum of the {@link #getConstraintMatchSet()}'s {@link ConstraintMatch#getScore()}.
     *
     * @return never null
     */
    func getScore() -> Score_

}

// default implementations
public extension Indictment {
    
    func getConstraintMatchCount() -> Int {
        return getConstraintMatchSet().count
    }
    
    func getJustificationList<ConstraintJustification_ : ConstraintJustification>(
            justificationClass: ConstraintJustification_.Type
    ) -> [ConstraintJustification_] {
        return getJustificationList().compactMap({ $0 as? ConstraintJustification_ })
    }
    
}
