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
 */
public final class PhaseLifecycleSupport<
        Solution_,
        Score_ : Score,
        Listener_ : PhaseLifecycleListener<Solution_, Score_>
> : AbstractEventSupport<Listener_> {

    @available(macOS 13.0.0, *)
    private func cast(_ listener: Any) -> any PhaseLifecycleListener<Solution_, Score_> {
        guard let listener = listener as? any PhaseLifecycleListener<Solution_, Score_> else {
            return unsupportedOperation("Check whether this cast can be removed!")
        }
        return listener
    }
    
    @available(macOS 13.0.0, *)
    public func fireSolvingStarted(_ solverScope: SolverScope<Solution_, Score_>) {
        for listener in getEventListeners() {
            cast(listener).solvingStarted(solverScope)
        }
    }

    @available(macOS 13.0.0, *)
    public func firePhaseStarted(_ phaseScope: AbstractPhaseScope<Solution_, Score_>) {
        for listener in getEventListeners() {
            cast(listener).phaseStarted(phaseScope)
        }
    }

    @available(macOS 13.0.0, *)
    public func fireStepStarted(_ stepScope: AbstractStepScope<Solution_, Score_>) {
        for listener in getEventListeners() {
            cast(listener).stepStarted(stepScope)
        }
    }

    @available(macOS 13.0.0, *)
    public func fireStepEnded(_ stepScope: AbstractStepScope<Solution_, Score_>) {
        for listener in getEventListeners() {
            cast(listener).stepEnded(stepScope)
        }
    }

    @available(macOS 13.0.0, *)
    public func firePhaseEnded(_ phaseScope: AbstractPhaseScope<Solution_, Score_>) {
        for listener in getEventListeners() {
            cast(listener).phaseEnded(phaseScope)
        }
    }

    @available(macOS 13.0.0, *)
    public func fireSolvingEnded(_ solverScope: SolverScope<Solution_, Score_>) {
        for listener in getEventListeners() {
            cast(listener).solvingEnded(solverScope)
        }
    }

    @available(macOS 13.0.0, *)
    public func fireSolvingError(solverScope: SolverScope<Solution_, Score_>, exception: Exception) {
        for listener in getEventListeners() {
            cast(listener).solvingError(solverScope: solverScope, exception: exception)
        }
    }
    
}
