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
 * A CompositeMove is composed out of multiple other moves.
 * <p>
 * Warning: each of moves in the moveList must not rely on the effect of a previous move in the moveList
 * to create its undoMove correctly.
 *
 * @param <Solution_> the solution type, the class with the {@link PlanningSolution} annotation
 * @see Move
 */
@available(macOS 13.0.0, *)
public class CompositeMove<Solution_> : Move, JavaStringConvertible {

    /**
     * @param moves never null, sometimes empty. Do not modify this argument afterwards or the CompositeMove corrupts.
     * @return never null
     */
    public static func buildMove<Move_ : Move<Solution_>>(moves: Move_...) -> any Move<Solution_> {
        return buildMove(moveList: moves)
    }

    /**
     * @param moveList never null, sometimes empty
     * @return never null
     */
    public static func buildMove<Move_ : Move<Solution_>>(moveList: [Move_]) -> any Move<Solution_> {
        let size = moveList.count
        if size > 1 {
            return CompositeMove(moveList)
        }
        if let first = moveList.first {
            return first
        }
        return NoChangeMove()
    }

    // ************************************************************************
    // Non-static members
    // ************************************************************************

    let moves: [any Move<Solution_>]

    /**
     * @param moves never null, never empty. Do not modify this argument afterwards or this CompositeMove corrupts.
     */
    public init(_ moves: [any Move<Solution_>]) {
        self.moves = moves
    }

    public func getMoves() -> [any Move<Solution_>] {
        return moves
    }

    public func isMoveDoable(scoreDirector: some ScoreDirector<Solution_>) -> Bool {
        return moves.allSatisfy({ $0.isMoveDoable(scoreDirector: scoreDirector) })
    }

    // TODO: Change return type
    public func doMove(scoreDirector: some ScoreDirector<Solution_>) -> any Move<Solution_> {
        var undoMoves: [any Move<Solution_>] = []
        for move in moves {
            if !move.isMoveDoable(scoreDirector: scoreDirector) {
                continue
            }
            // Calls scoreDirector.triggerVariableListeners() between moves
            // because a later move can depend on the shadow variables changed by an earlier move
            let undoMove = move.doMove(scoreDirector: scoreDirector)
            // Undo in reverse order and each undoMove is created after previous moves have been done
            undoMoves.insert(undoMove, at: 0)
        }
        // No need to call scoreDirector.triggerVariableListeners() because Move.doMove() already does it for every move.
        return CompositeMove(undoMoves)
    }

    public func rebase(
            destinationScoreDirector: some ScoreDirector<Solution_>
    ) -> any Move<Solution_> {
        return CompositeMove(moves.map({
            $0.rebase(destinationScoreDirector: destinationScoreDirector)
        }))
    }

    // ************************************************************************
    // Introspection methods
    // ************************************************************************

    public func getSimpleMoveTypeDescription() -> String {
        var result = String(describing: type(of: self))
        result.append("(")
        result.append( // WIP: Check effects of using TreeSet
            moves.map({ "* " + $0.getSimpleMoveTypeDescription() }).joined(separator: ", ")
        )
        result.append(")")
        return result
    }

    public func getPlanningEntities() -> any Collection {
        var entities = [Any]() // WIP: Check effects of using Set
        for move in moves {
            for entity in move.getPlanningEntities() {
                entities.append(entity)
            }
        }
        return entities
    }

    public func getPlanningValues() -> any Collection {
        var values = [Any]() // WIP: Check effects of using Set
        for move in moves {
            for value in move.getPlanningValues() {
                values.append(value)
            }
        }
        return values
    }
    
    public static func == (lhs: CompositeMove<Solution_>, rhs: CompositeMove<Solution_>) -> Bool {
        return Equals.checkArray(
            lhs.moves,
            rhs.moves,
            orElse: {
                missingFeature(
                    "(At least) one of these types misses Equatable conformance: "
                        + String(describing: type(of: $0)) + " or "
                        + String(describing: type(of: $1))
                )
            }
        )
    }
    
    public func hash(into hasher: inout Hasher) {
        for move in moves {
            hasher.combine(move)
        }
    }

    public func toString() -> String {
        return moves.description
    }

}
