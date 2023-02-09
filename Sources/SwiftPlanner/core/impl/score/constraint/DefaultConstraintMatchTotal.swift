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

public final class DefaultConstraintMatchTotal<Score_ : Score> : ConstraintMatchTotal, Hashable, JavaStringConvertible, SPComparableAndEquatable {

    private let constraintPackage: String
    private let constraintName: String
    private let constraintId: String
    private let constraintWeight: Score_?

    private var constraintMatchSet: Set<ConstraintMatch<Score_>> = []
    private var score: Score_? = nil

    public init(package constraintPackage: String, name constraintName: String) {
        self.constraintPackage = constraintPackage
        self.constraintName = constraintName
        self.constraintId = ConstraintMatchUtil.composeConstraintId(
            package: constraintPackage,
            name: constraintName
        )
        self.constraintWeight = nil
    }

    public init(
            package constraintPackage: String,
            name constraintName: String,
            weight constraintWeight: Score_
    ) {
        self.constraintPackage = constraintPackage
        self.constraintName = constraintName
        self.constraintId = ConstraintMatchUtil.composeConstraintId(
            package: constraintPackage,
            name: constraintName
        )
        self.constraintWeight = constraintWeight
        self.score = constraintWeight.zero()
    }

    public func getConstraintPackage() -> String {
        return constraintPackage
    }

    public func getConstraintName() -> String {
        return constraintName
    }

    public func getConstraintWeight() -> Score_? {
        return constraintWeight
    }

    public func getConstraintMatchSet() -> Set<ConstraintMatch<Score_>> {
        return constraintMatchSet
    }

    public func getScore() -> Score_ {
        guard let score = score else {
            return assertionFailure(
                "getScore method of DefaultConstraintMatchTotal " + self
                + " called before score has been set"
            )
        }
        return score
    }

    // ************************************************************************
    // Worker methods
    // ************************************************************************

    /**
     * Creates a {@link ConstraintMatch} and adds it to the collection returned by {@link #getConstraintMatchSet()}.
     * It will use {@link DefaultConstraintJustification},
     * whose {@link DefaultConstraintJustification#getFacts()} method will return the given list of justifications.
     * Additionally, the constraint match will indict the objects in the given list of justifications.
     *
     * @param justifications never null, never empty
     * @param score never null
     * @return never null
     */
    public func addConstraintMatch(
            justifications: [CustomStringConvertible],
            score: Score_
    ) -> ConstraintMatch<Score_> {
        return addConstraintMatch(
            justification: DefaultConstraintJustification.of(score, facts: justifications),
            indictedObjects: justifications,
            score: score
        )
    }

    /**
     * Creates a {@link ConstraintMatch} and adds it to the collection returned by {@link #getConstraintMatchSet()}.
     * It will the provided {@link ConstraintJustification}.
     * Additionally, the constraint match will indict the objects in the given list of indicted objects.
     *
     * @param indictedObjects never null, may be empty
     * @param score never null
     * @return never null
     */
    public func addConstraintMatch(
            justification: ConstraintJustification,
            indictedObjects: [Any],
            score: Score_
    ) -> ConstraintMatch<Score_> {
        self.score = self.score ??! { $0.add(score) } ..! score
        let constraintMatch = ConstraintMatch(
            constraintPackage: constraintPackage,
            constraintName: constraintName,
            justification: justification,
            indictedObjects: indictedObjects,
            score: score
        )
        constraintMatchSet.insert(constraintMatch)
        return constraintMatch
    }

    public func removeConstraintMatch(_ constraintMatch: ConstraintMatch<Score_>) {
        score = score?.subtract(constraintMatch.getScore())
        let removed = constraintMatchSet.remove(constraintMatch)
        assert(
            removed != nil,
            "The constraintMatchTotal (" + self + ") could not remove constraintMatch ("
                + constraintMatch + ") from its constraintMatchSet (" + constraintMatchSet + ")."
        )
    }

    // ************************************************************************
    // Infrastructure methods
    // ************************************************************************

    public func getConstraintId() -> String {
        return constraintId
    }

    public func compare(to other: DefaultConstraintMatchTotal<Score_>) -> ComparisonResult {
        return constraintId.compare(to: other.constraintId)
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(constraintPackage)
        hasher.combine(constraintName)
    }

    public func toString() -> String {
        return getConstraintId() + "=" + String(describing: score)
    }

}
