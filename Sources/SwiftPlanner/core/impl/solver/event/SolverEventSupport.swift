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
 * Internal API.
 *
 * @param <Solution_> the solution type, the class with the {@link PlanningSolution} annotation
 */
public class SolverEventSupport<
        Solution_,
        Listener_ : SolverEventListener<Solution_>
> : AbstractEventSupport<Listener_> {

    private let solver: any Solver<Solution_>

    public init(solver: any Solver<Solution_>) {
        self.solver = solver
    }

    @available(macOS 13.0.0, *)
    public func fireBestSolutionChanged<Score_ : Score>(
            solverScope: SolverScope<Solution_, Score_>,
            newBestSolution: Solution_
    ) {
        let timeNanosSpent = solverScope.getBestSolutionTimeNanosSpent()
        guard let bestScore = solverScope.getBestScore() else {
            unsupportedOperation("Check this edge case!")
            return
        }
        let eventListeners = getEventListeners()
        if eventListeners.isEmpty {
            return
        }
        let event = BestSolutionChangedEvent(
            solver: solver,
            timeNanosSpent: timeNanosSpent,
            newBestSolution: newBestSolution,
            newBestScore: bestScore
        )
        for eventListener in eventListeners {
            guard let listener = eventListener as? any SolverEventListener<Solution_> else {
                unsupportedOperation("Check whether this cast can be removed!")
                return
            }
            listener.bestSolutionChanged(event: event)
        }
    }

}
