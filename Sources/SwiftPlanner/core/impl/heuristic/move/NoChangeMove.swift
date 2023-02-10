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
 * Makes no changes.
 *
 * @param <Solution_> the solution type, the class with the {@link PlanningSolution} annotation
 */
public class NoChangeMove<Solution_> : AbstractMove, JavaStringConvertible {

    public func isMoveDoable(scoreDirector: some ScoreDirector<Solution_>) -> Bool {
        return true
    }

    public func createUndoMove(
            scoreDirector: some ScoreDirector<Solution_>
    ) -> any Move<Solution_> {
        return NoChangeMove()
    }

    public func doMoveOnGenuineVariables(scoreDirector: some ScoreDirector<Solution_>) {
        // do nothing
    }

    public func rebase(
            destinationScoreDirector: some ScoreDirector<Solution_>
    ) -> any Move<Solution_> {
        return NoChangeMove()
    }

    // ************************************************************************
    // Introspection methods
    // ************************************************************************

    public func getPlanningEntities() -> any Collection {
        return []
    }

    public func getPlanningValues() -> any Collection {
        return []
    }
    
    public static func == (lhs: NoChangeMove<Solution_>, rhs: NoChangeMove<Solution_>) -> Bool {
        return true // WIP: Check whether distinction is needed (see hash(into:), too).
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(1) // WIP: Check whether distinction is needed (see ==, too).
    }

    public func toString() -> String {
        return "No change"
    }

}
