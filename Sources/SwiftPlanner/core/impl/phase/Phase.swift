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
 * A phase of a {@link Solver}.
 *
 * @param <Solution_> the solution type, the class with the {@link PlanningSolution} annotation
 * @see AbstractPhase
 */
public protocol Phase<Solution_, Score_> : PhaseLifecycleListener {

    /**
     * Add a {@link PhaseLifecycleListener} that is only notified
     * of the {@link PhaseLifecycleListener#phaseStarted(AbstractPhaseScope) phase}
     * and the {@link PhaseLifecycleListener#stepStarted(AbstractStepScope) step} starting/ending events from this phase
     * (and the {@link PhaseLifecycleListener#solvingStarted(SolverScope) solving} events too of course).
     * <p>
     * To get notified for all phases, use {@link DefaultSolver#addPhaseLifecycleListener(PhaseLifecycleListener)} instead.
     *
     * @param phaseLifecycleListener never null
     */
    func addPhaseLifecycleListener(_ phaseLifecycleListener: any PhaseLifecycleListener<Solution_, Score_>)

    /**
     * @param phaseLifecycleListener never null
     * @see #addPhaseLifecycleListener(PhaseLifecycleListener)
     */
    func removePhaseLifecycleListener(_ phaseLifecycleListener: any PhaseLifecycleListener<Solution_, Score_>)

    func solve(_ solverScope: SolverScope<Solution_, Score_>)
    
    // WIP: Check whether it has to be restricted to AbstractSolver.
    func setSolver(_ solver: any Solver<Solution_>)

}
