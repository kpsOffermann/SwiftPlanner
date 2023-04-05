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
 * A Termination determines when a {@link Solver} or a {@link Phase} should stop.
 * <p>
 * An implementation must extend {@link AbstractTermination} to ensure backwards compatibility in future versions.
 *
 * @see AbstractTermination
 *
 * WIP-Note: Other than in the original, there is no AbstractTermination in SwiftPlanner.
 */
public protocol Termination<Solution_, Score_> : PhaseLifecycleListener {

    /**
     * Called by the {@link Solver} after every phase to determine if the search should stop.
     *
     * @param solverScope never null
     * @return true if the search should terminate.
     */
    func isSolverTerminated(_ solverScope: SolverScope<Solution_, Score_>) -> Bool

    /**
     * Called by the {@link Phase} after every step and every move to determine if the search should stop.
     *
     * @param phaseScope never null
     * @return true if the search should terminate.
     */
    func isPhaseTerminated(_ phaseScope: AbstractPhaseScope<Solution_, Score_>) -> Bool

    /**
     * A timeGradient is a relative estimate of how long the search will continue.
     * <p>
     * Clients that use a timeGradient should cache it at the start of a single step
     * because some implementations are not time-stable.
     * <p>
     * If a timeGradient cannot be calculated, it should return -1.0.
     * Several implementations (such a {@link SimulatedAnnealingAcceptor}) require a correctly implemented timeGradient.
     * <p>
     * A Termination's timeGradient can be requested after they are terminated, so implementations
     * should be careful not to return a timeGradient above 1.0.
     *
     * @param solverScope never null
     * @return timeGradient t for which {@code 0.0 <= t <= 1.0 or -1.0} when it is not supported.
     *         At the start of a solver t is 0.0 and at the end t would be 1.0.
     */
    func calculateSolverTimeGradient(_ solverScope: SolverScope<Solution_, Score_>) -> Double

    /**
     * See {@link #calculateSolverTimeGradient(SolverScope)}.
     *
     * @param phaseScope never null
     * @return timeGradient t for which {@code 0.0 <= t <= 1.0 or -1.0} when it is not supported.
     *         At the start of a phase t is 0.0 and at the end t would be 1.0.
     */
    func calculatePhaseTimeGradient(_ phaseScope: AbstractPhaseScope<Solution_, Score_>) -> Double

    /**
     * Create a {@link Termination} for a child {@link Thread} of the {@link Solver}.
     *
     * @param solverScope never null
     * @param childThreadType never null
     * @return not null
     * @throws UnsupportedOperationException if not supported by this termination
     */
    func createChildThreadTermination(
            solverScope: SolverScope<Solution_, Score_>,
            childThreadType: ChildThreadType
    ) -> any Termination<Solution_, Score_>

}
