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
 * A Move represents a change of 1 or more {@link PlanningVariable}s of 1 or more {@link PlanningEntity}s
 * in the working {@link PlanningSolution}.
 * <p>
 * Usually the move holds a direct reference to each {@link PlanningEntity} of the {@link PlanningSolution}
 * which it will change when {@link #doMove(ScoreDirector)} is called.
 * On that change it should also notify the {@link ScoreDirector} accordingly.
 * <p>
 * A Move should implement {@link Object#equals(Object)} and {@link Object#hashCode()} for {@link MoveTabuAcceptor}.
 * <p>
 * An implementation must extend {@link AbstractMove} to ensure backwards compatibility in future versions.
 *
 * @param <Solution_> the solution type, the class with the {@link PlanningSolution} annotation
 * @see AbstractMove
 */
public protocol Move<Solution_> : Hashable {
    
    associatedtype Solution_

    /**
     * Called before a move is evaluated to decide whether the move can be done and evaluated.
     * A Move is not doable if:
     * <ul>
     * <li>Either doing it would change nothing in the {@link PlanningSolution}.</li>
     * <li>Either it's simply not possible to do (for example due to built-in hard constraints).</li>
     * </ul>
     * <p>
     * It is recommended to keep this method implementation simple: do not use it in an attempt to satisfy normal
     * hard and soft constraints.
     * <p>
     * Although you could also filter out non-doable moves in for example the {@link MoveSelector}
     * or {@link MoveListFactory}, this is not needed as the {@link Solver} will do it for you.
     *
     * @param scoreDirector the {@link ScoreDirector} not yet modified by the move.
     * @return true if the move achieves a change in the solution and the move is possible to do on the solution.
     */
    func isMoveDoable(scoreDirector: some ScoreDirector<Solution_>) -> Bool

    /**
     * Does the move (which indirectly affects the {@link ScoreDirector#getWorkingSolution()}).
     * When the {@link PlanningSolution working solution} is modified, the {@link ScoreDirector} must be correctly notified
     * (through {@link ScoreDirector#beforeVariableChanged(Object, String)} and
     * {@link ScoreDirector#afterVariableChanged(Object, String)}),
     * otherwise later calculated {@link Score}s will be corrupted.
     * <p>
     * This method must end with calling {@link ScoreDirector#triggerVariableListeners()} to ensure all shadow variables are
     * updated.
     * <p>
     * This method must return an undo move, so the move can be evaluated and then be undone
     * without resulting into a permanent change in the solution.
     *
     * @param scoreDirector never null, the {@link ScoreDirector} that needs to get notified of the changes
     * @return an undoMove which does the exact opposite of this move
     */
    func doMove(scoreDirector: some ScoreDirector<Solution_>) -> any Move<Solution_>

    /**
     * As defined by {@link #doMove(ScoreDirector)}, but does not return an undo move.
     *
     * @param scoreDirector never null, the {@link ScoreDirector} that needs to get notified of the changes
     */
    func doMoveOnly(scoreDirector: some ScoreDirector<Solution_>)

    /**
     * Rebases a move from an origin {@link ScoreDirector} to another destination {@link ScoreDirector}
     * which is usually on another {@link Thread} or JVM.
     * The new move returned by this method translates the entities and problem facts
     * to the destination {@link PlanningSolution} of the destination {@link ScoreDirector},
     * That destination {@link PlanningSolution} is a deep planning clone (or an even deeper clone)
     * of the origin {@link PlanningSolution} that this move has been generated from.
     * <p>
     * That new move does the exact same change as this move,
     * resulting in the same {@link PlanningSolution} state,
     * presuming that destination {@link PlanningSolution} was in the same state
     * as the original {@link PlanningSolution} to begin with.
     * <p>
     * Generally speaking, an implementation of this method iterates through every entity and fact instance in this move,
     * translates each one to the destination {@link ScoreDirector} with {@link ScoreDirector#lookUpWorkingObject(Object)}
     * and creates a new move instance of the same move type, using those translated instances.
     * <p>
     * The destination {@link PlanningSolution} can be in a different state than the original {@link PlanningSolution}.
     * So, rebasing can only depend on the identity of {@link PlanningEntity planning entities} and planning facts,
     * which is usually declared by a {@link PlanningId} on those classes.
     * It must not depend on the state of the {@link PlanningVariable planning variables}.
     * One thread might rebase a move before, amid or after another thread does that same move instance.
     * <p>
     * This method is thread-safe.
     *
     * @param destinationScoreDirector never null, the {@link ScoreDirector#getWorkingSolution()}
     *        that the new move should change the planning entity instances of.
     * @return never null, a new move that does the same change as this move on another solution instance
     */
    func rebase(destinationScoreDirector: some ScoreDirector<Solution_>) -> any Move<Solution_>

    // ************************************************************************
    // Introspection methods
    // ************************************************************************

    /**
     * Describes the move type for statistical purposes.
     * For example "ChangeMove(Process.computer)".
     * <p>
     * The format is not formalized. Never parse the {@link String} returned by this method.
     *
     * @return never null
     */
    func getSimpleMoveTypeDescription() -> String

    /**
     * Returns all planning entities that are being changed by this move.
     * Required for {@link AcceptorType#ENTITY_TABU}.
     * <p>
     * This method is only called after {@link #doMove(ScoreDirector)} (which might affect the return values).
     * <p>
     * Duplicate entries in the returned {@link Collection} are best avoided.
     * The returned {@link Collection} is recommended to be in a stable order.
     * For example: use {@link List} or {@link LinkedHashSet}, but not {@link HashSet}.
     *
     * @return never null
     */
    func getPlanningEntities() -> any Collection

    /**
     * Returns all planning values that entities are being assigned to by this move.
     * Required for {@link AcceptorType#VALUE_TABU}.
     * <p>
     * This method is only called after {@link #doMove(ScoreDirector)} (which might affect the return values).
     * <p>
     * Duplicate entries in the returned {@link Collection} are best avoided.
     * The returned {@link Collection} is recommended to be in a stable order.
     * For example: use {@link List} or {@link LinkedHashSet}, but not {@link HashSet}.
     *
     * @return never null
     */
    func getPlanningValues() -> any Collection

}

// default implementations
public extension Move {
    
    // WIP: Check whether this backwards compatibility is still needed
    func doMoveOnly(scoreDirector: some ScoreDirector<Solution_>) {
        // For backwards compatibility, this method is default and calls doMove(...).
        // Normally, the relationship is inversed, as implemented in AbstractMove.
        _ = doMove(scoreDirector: scoreDirector)
    }
    
    func rebase(destinationScoreDirector: some ScoreDirector<Solution_>) -> any Move<Solution_> {
        unsupportedOperation(
            "The custom move class (" + String(describing: type(of: self))
                + ") doesn't implement the rebase() method, so multithreaded solving is impossible."
        )
        fatalError("Unreachable source code")
    }
    
    func getSimpleMoveTypeDescription() -> String {
        return String(describing: type(of: self))
    }
    
    func getPlanningEntities() -> any Collection {
        return unsupportedOperation(
            "The custom move class (" + String(describing: type(of: self))
                + ") doesn't implement the getPlanningEntities() method, "
                + "so Entity Tabu Search is impossible."
        )
    }
    
    func getPlanningValues() -> any Collection {
        return unsupportedOperation(
            "The custom move class (" + String(describing: type(of: self))
                + ") doesn't implement the getPlanningEntities() method, "
                + "so Value Tabu Search is impossible."
        )
    }
    
}
