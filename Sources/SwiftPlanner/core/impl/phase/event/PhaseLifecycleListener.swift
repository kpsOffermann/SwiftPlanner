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
 * @param <Solution_> the solution type, the class with the {@link PlanningSolution} annotation
 * @see PhaseLifecycleListenerAdapter
 */
public protocol PhaseLifecycleListener<Solution_, Score_> : SolverLifecycleListener {

    func phaseStarted(_ phaseScope: AbstractPhaseScope<Solution_, Score_>)

    func stepStarted(_ stepScope: AbstractStepScope<Solution_, Score_>)

    func stepEnded(_ stepScope: AbstractStepScope<Solution_, Score_>)

    func phaseEnded(_ phaseScope: AbstractPhaseScope<Solution_, Score_>)

}

@available(macOS 13.0.0, *)
public class WrappedPhaseLifecycleListener<
        Solution_ : PlanningSolution,
        Score_ : Score
> : WrappedSolverLifecycleListener<Solution_, Score_>, PhaseLifecycleListener {
    
    private let wrapped: any PhaseLifecycleListener<Solution_, Score_>
    
    public init(_ wrapped: some PhaseLifecycleListener<Solution_, Score_>) {
        self.wrapped = wrapped
        super.init(wrapped)
    }
    
    public func phaseStarted(_ phaseScope: AbstractPhaseScope<Solution_, Score_>) {
        wrapped.phaseStarted(phaseScope)
    }

    public func stepStarted(_ stepScope: AbstractStepScope<Solution_, Score_>) {
        wrapped.stepStarted(stepScope)
    }

    public func stepEnded(_ stepScope: AbstractStepScope<Solution_, Score_>) {
        wrapped.stepEnded(stepScope)
    }

    public func phaseEnded(_ phaseScope: AbstractPhaseScope<Solution_, Score_>) {
        wrapped.phaseEnded(phaseScope)
    }
    
    public static func == (
            lhs: WrappedPhaseLifecycleListener<Solution_, Score_>,
            rhs: WrappedPhaseLifecycleListener<Solution_, Score_>
    ) -> Bool {
        return Equals.check(lhs.wrapped, rhs.wrapped, orElse: { lhs === rhs })
    }
    
}
