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
 * Abstract superclass for {@link Move}.
 *
 * @param <Solution_> the solution type, the class with the {@link PlanningSolution} annotation
 * @see Move
 */
public protocol AbstractMove<Solution_> : Move {

    /**
     * Called before the move is done, so the move can be evaluated and then be undone
     * without resulting into a permanent change in the solution.
     *
     * @param scoreDirector the {@link ScoreDirector} not yet modified by the move.
     * @return an undoMove which does the exact opposite of this move.
     */
    func createUndoMove(scoreDirector: some ScoreDirector<Solution_>) -> any Move<Solution_>

    /**
     * Like {@link #doMoveOnly(ScoreDirector)} but without the {@link ScoreDirector#triggerVariableListeners()} call
     * (because {@link #doMoveOnly(ScoreDirector)} already does that).
     *
     * @param scoreDirector never null
     */
    func doMoveOnGenuineVariables(scoreDirector: some ScoreDirector<Solution_>)

}

public extension AbstractMove {
    
    func doMove(scoreDirector: some ScoreDirector<Solution_>) -> any Move<Solution_> {
        let undoMove = createUndoMove(scoreDirector: scoreDirector)
        doMoveOnly(scoreDirector: scoreDirector)
        return undoMove
    }

    func doMoveOnly(scoreDirector: some ScoreDirector<Solution_>) {
        doMoveOnGenuineVariables(scoreDirector: scoreDirector)
        scoreDirector.triggerVariableListeners()
    }
    
}
