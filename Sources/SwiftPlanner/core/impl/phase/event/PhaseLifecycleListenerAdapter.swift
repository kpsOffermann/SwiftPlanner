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
 * An adapter for {@link PhaseLifecycleListener}.
 *
 * @param <Solution_> the solution type, the class with the {@link PlanningSolution} annotation
 */
public /*abstract*/ class PhaseLifecycleListenerAdapter<
        Solution_ : PlanningSolution,
        Score_ : Score
> : SolverLifecycleListenerAdapter<Solution_, Score_>, PhaseLifecycleListener {

    public func phaseStarted(_ phaseScope: AbstractPhaseScope<Solution_, Score_>) {
        // Hook method
    }

    public func stepStarted(_ stepScope: AbstractStepScope<Solution_, Score_>) {
        // Hook method
    }

    public func stepEnded(_ stepScope: AbstractStepScope<Solution_, Score_>) {
        // Hook method
    }

    public func phaseEnded(_ phaseScope: AbstractPhaseScope<Solution_, Score_>) {
        // Hook method
    }

}
