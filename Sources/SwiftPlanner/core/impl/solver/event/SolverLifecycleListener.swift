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

// WIP: Specialize type further according to actual use cases.
public typealias Exception = Any

/**
 * @param <Solution_> the solution type, the class with the {@link PlanningSolution} annotation
 * @see SolverLifecycleListenerAdapter
 */
public protocol SolverLifecycleListener<Solution_, Score_> : EventListener {
    
    associatedtype Solution_
    
    associatedtype Score_ : Score

    func solvingStarted(_ solverScope: SolverScope<Solution_, Score_>)

    func solvingEnded(_ solverScope: SolverScope<Solution_, Score_>)

    /**
     * Invoked in case of an exception in the {@link org.optaplanner.core.api.solver.Solver} run. In that case,
     * the {@link #solvingEnded(SolverScope)} is never called.
     * For internal purposes only.
     */
    func solvingError(solverScope: SolverScope<Solution_, Score_>, exception: Exception)
    
}

// Default implementations
extension SolverLifecycleListener {
    
    public func solvingError(solverScope: SolverScope<Solution_, Score_>, exception: Exception) {
        // do nothing
    }
    
}

@available(macOS 13.0.0, *)
public class WrappedSolverLifecycleListener<
        Solution_,
        Score_ : Score
> : SolverLifecycleListener, Equatable {
    
    private var wrapped: any SolverLifecycleListener<Solution_, Score_>
    
    public init(_ wrapped: any SolverLifecycleListener<Solution_, Score_>) {
        self.wrapped = wrapped
    }
    
    public func solvingStarted(_ solverScope: SolverScope<Solution_, Score_>) {
        wrapped.solvingStarted(solverScope)
    }

    public func solvingEnded(_ solverScope: SolverScope<Solution_, Score_>) {
        wrapped.solvingEnded(solverScope)
    }

    public func solvingError(solverScope: SolverScope<Solution_, Score_>, exception: Exception) {
        wrapped.solvingError(solverScope: solverScope, exception: exception)
    }
    
    public static func == (
            lhs: WrappedSolverLifecycleListener<Solution_, Score_>,
            rhs: WrappedSolverLifecycleListener<Solution_, Score_>
    ) -> Bool {
        return Equals.check(lhs.wrapped, rhs.wrapped, orElse: { lhs === rhs })
    }
    
}
