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

// WIP: Features of EventListener

/**
 * @param <Solution_> the solution type, the class with the {@link PlanningSolution} annotation
 */
public protocol SolverEventListener<Solution_> : EventListener {
    
    associatedtype Solution_

    /**
     * Called once every time when a better {@link PlanningSolution} is found.
     * The {@link PlanningSolution} is guaranteed to be initialized.
     * Early in the solving process it's usually called more frequently than later on.
     * <p>
     * Called from the solver thread.
     * <b>Should return fast, because it steals time from the {@link Solver}.</b>
     * <p>
     * In real-time planning
     * If {@link Solver#addProblemChange(ProblemChange)} has been called once or more,
     * all {@link ProblemChange}s in the queue will be processed and this method is called only once.
     * In that case, the former best {@link PlanningSolution} is considered stale,
     * so it doesn't matter whether the new {@link Score} is better than that or not.
     *
     * @param event never null
     */
    func bestSolutionChanged(event: BestSolutionChangedEvent<Solution_>)

}

@available(macOS 13.0.0, *)
public class WrappedSolverEventListener<Solution_> : SolverEventListener, Equatable {
    
    private var wrapped: any SolverEventListener<Solution_>
    
    public init(_ wrapped: some SolverEventListener<Solution_>) {
        self.wrapped = wrapped
    }
    
    public func bestSolutionChanged(event: BestSolutionChangedEvent<Solution_>) {
        wrapped.bestSolutionChanged(event: event)
    }
    
    public static func == (
            lhs: WrappedSolverEventListener<Solution_>,
            rhs: WrappedSolverEventListener<Solution_>
    ) -> Bool {
        return Equals.check(lhs.wrapped, rhs.wrapped, orElse: { lhs === rhs })
    }
    
}
