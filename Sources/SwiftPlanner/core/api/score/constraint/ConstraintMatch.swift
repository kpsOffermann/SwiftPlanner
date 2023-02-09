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

import Foundation

/**
 * Retrievable from {@link ConstraintMatchTotal#getConstraintMatchSet()}
 * and {@link Indictment#getConstraintMatchSet()}.
 *
 * <p>
 * This class implements {@link Comparable} for consistent ordering of constraint matches in visualizations.
 * The details of this ordering are unspecified and are subject to change.
 *
 * @param <Score_> the actual score type
 */
public final class ConstraintMatch<Score_ : Score> : SPComparable, JavaStringConvertible, Hashable {

    private let constraintPackage: String
    private let constraintName: String
    private let constraintId: String

    private let justification: ConstraintJustification
    private let indictedObjects: [Any]
    private let score: Score_

    /**
     * @param constraintPackage never null
     * @param constraintName never null
     * @param justification never null
     * @param score never null
     */
    public init(
            constraintPackage: String,
            constraintName: String,
            justification: ConstraintJustification,
            indictedObjects: [Any],
            score: Score_
    ) {
        self.constraintPackage = constraintPackage
        self.constraintName = constraintName
        self.constraintId = ConstraintMatchUtil.composeConstraintId(
            package: constraintPackage,
            name: constraintName
        )
        self.justification = justification
        self.indictedObjects = indictedObjects
        self.score = score
    }

    public func getConstraintPackage() -> String {
        return constraintPackage
    }

    public func getConstraintName() -> String {
        return constraintName
    }

    /**
     * Return a singular justification for the constraint.
     * <p>
     * This method has a different meaning based on which score director the constraint comes from.
     * <ul>
     * <li>For Score DRL, it returns {@link DefaultConstraintJustification} of all objects
     * that Drools considers to be part of the match.
     * This is largely undefined.</li>
     * <li>For incremental score calculation, it returns what the calculator is implemented to return.</li>
     * <li>For constraint streams, it returns {@link DefaultConstraintJustification} from the matching tuple
     * (eg. [A, B] for a bi stream), unless a custom justification mapping was provided,
     * in which case it returns the return value of that function.</li>
     * </ul>
     *
     * @return never null
     */
    public func getJustification() -> ConstraintJustification {
        return justification
    }

    /**
     * Returns a set of objects indicted for causing this constraint match.
     * <p>
     * This method has a different meaning based on which score director the constraint comes from.
     * <ul>
     * <li>For Score DRL, it returns {@link DefaultConstraintJustification} of all objects
     * that Drools considers to be part of the match.
     * This is largely undefined.</li>
     * <li>For incremental score calculation, it returns what the calculator is implemented to return.</li>
     * <li>For constraint streams, it returns the facts from the matching tuple
     * (eg. [A, B] for a bi stream), unless a custom indictment mapping was provided,
     * in which case it returns the return value of that function.</li>
     * </ul>
     *
     * @return never null, may be empty
     */
    public func getIndictedObjectList() -> [Any] {
        return indictedObjects
    }

    public func getScore() -> Score_ {
        return score
    }

    // ************************************************************************
    // Worker methods
    // ************************************************************************

    public func getConstraintId() -> String {
        return ConstraintMatchUtil.composeConstraintId(
            package: constraintPackage,
            name: constraintName
        )
    }

    public func getIdentificationString() -> String {
        return getConstraintId() + "/" + justification
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(constraintId)
        hasher.combine(score)
        if let justificationHash = justification as? any Hashable {
            hasher.combine(justificationHash)
        } else {
            hasher.combine(ObjectIdentifier(justification))
        }
    }
    
    public static func ==(lhs: ConstraintMatch, rhs: ConstraintMatch) -> Bool {
        return lhs === rhs // no constraint match should equal any other.
    }
    
    public func compare(to other: ConstraintMatch) -> ComparisonResult {
        chainCompare(
            self,
            other,
            by: ©\.constraintId,
            ©\.score,
            Comparators.by(
                \.justification,
                 orElse: {
                     ObjectIdentifier.compare(.init(self.justification), .init(other.justification))
                 }
            )
        )
    }
    
    public func toString() -> String {
        return getIdentificationString() + "=" + score
    }

}
