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

// WIP: Distinctiveness of elements in justification list.

public final class DefaultIndictment<Score_ : Score> : Indictment, Equatable, Hashable, JavaStringConvertible {
    
    public typealias Object = CustomStringConvertible & Hashable

    private let indictedObject: any Object
    private var constraintMatchSet: Set<ConstraintMatch<Score_>> = []
    private var constraintJustificationList: [ConstraintJustification]? = nil
    private var score: Score_

    public init(indictedObject: some Object, zeroScore: Score_) {
        self.indictedObject = indictedObject
        self.score = zeroScore
    }

    public func getIndictedObject() -> CustomStringConvertible {
        return indictedObject
    }

    public func getConstraintMatchSet() -> Set<ConstraintMatch<Score_>> {
        return constraintMatchSet
    }

    public func getJustificationList() -> [ConstraintJustification] {
        if let result = constraintJustificationList {
            return result
        }
        let result = constraintMatchSet.map({ $0.getJustification() }) // WIP: .distinct()
        constraintJustificationList = result
        return result
    }

    public func getScore() -> Score_ {
        return score
    }

    // ************************************************************************
    // Worker methods
    // ************************************************************************

    public func addConstraintMatch(_ constraintMatch: ConstraintMatch<Score_>) {
        score = score.add(constraintMatch.getScore())
        assert(
            constraintMatchSet.insert(constraintMatch).inserted,
            "The indictment (" + self + ") could not add constraintMatch (" + constraintMatch
                + ") to its constraintMatchSet (" + constraintMatchSet + ")."
        )
        constraintJustificationList = nil // Rebuild later.
    }

    public func removeConstraintMatch(_ constraintMatch: ConstraintMatch<Score_>) {
        score = score.subtract(constraintMatch.getScore())
        assert(
            constraintMatchSet.removeFirstEqual(constraintMatch),
            "The indictment (" + self + ") could not remove constraintMatch (" + constraintMatch
                + ") from its constraintMatchSet (" + constraintMatchSet + ")."
        )
        constraintJustificationList = nil // Rebuild later.
    }

    // ************************************************************************
    // Infrastructure methods
    // ************************************************************************

    public static func ==(lhs: DefaultIndictment, rhs: DefaultIndictment) -> Bool {
        return lhs.indictedObject.isEqual(to: rhs.indictedObject)
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(indictedObject)
    }

    public func toString() -> String {
        return indictedObject + "=" + score
    }

}
