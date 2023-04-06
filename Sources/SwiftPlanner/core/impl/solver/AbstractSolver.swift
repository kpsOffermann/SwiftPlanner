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

// WIP: Logger
/* WIP: requires SolutionDescriptor for
        runPhases
 */

@available(macOS 13.0.0, *)
public typealias AbstractSolver<Solution_, Score_ : Score> = AbstractSolverClass<Solution_, Score_> & Solver

/**
 * Common code between {@link DefaultSolver} and child solvers (such as {@link PartitionSolver}).
 * <p>
 * Do not create a new child {@link Solver} to implement a new heuristic or metaheuristic,
 * just use a new {@link Phase} for that.
 *
 * @param <Solution_> the solution type, the class with the {@link PlanningSolution} annotation
 * @see Solver
 * @see DefaultSolver
 */
@available(macOS 13.0.0, *)
public /*abstract*/ class AbstractSolverClass<Solution_, Score_ : Score> /*: Solver*/ {

    // WIP: Logger
    //protected final transient Logger logger = LoggerFactory.getLogger(getClass());

    private let solverEventSupport = SolverEventSupport<
        Solution_,
        WrappedSolverEventListener<Solution_>
    >()
    
    private let phaseLifecycleSupport = PhaseLifecycleSupport<
        Solution_,
        Score_,
        WrappedPhaseLifecycleListener<Solution_, Score_>
    >()

    public let bestSolutionRecaller: BestSolutionRecaller<Solution_, Score_, WrappedSolverEventListener<Solution_>>
    // Note that the DefaultSolver.basicPlumbingTermination is a component of this termination.
    // Called "solverTermination" to clearly distinguish from "phaseTermination" inside AbstractPhase.
    let solverTermination: any Termination<Solution_, Score_>
    public let phaseList: [any Phase<Solution_, Score_>]

    // ************************************************************************
    // Constructors and simple getters/setters
    // ************************************************************************

    public init(
            bestSolutionRecaller: BestSolutionRecaller<Solution_, Score_, WrappedSolverEventListener<Solution_>>,
            solverTermination: any Termination<Solution_, Score_>,
            phaseList: [any Phase<Solution_, Score_>]
    ) {
        self.bestSolutionRecaller = bestSolutionRecaller
        self.solverTermination = solverTermination
        self.phaseList = phaseList
        guard let selfAsSolver = self as? (any Solver<Solution_>) else {
            return
        }
        self.solverEventSupport.setSolver(selfAsSolver)
        bestSolutionRecaller.setSolverEventSupport(solverEventSupport)
        for phase in phaseList {
            phase.setSolver(selfAsSolver)
        }
    }

    // ************************************************************************
    // Lifecycle methods
    // ************************************************************************

    public func solvingStarted(_ solverScope: SolverScope<Solution_, Score_>) {
        solverScope.setWorkingSolutionFromBestSolution()
        bestSolutionRecaller.solvingStarted(solverScope)
        solverTermination.solvingStarted(solverScope)
        phaseLifecycleSupport.fireSolvingStarted(solverScope)
        for phase in phaseList {
            phase.solvingStarted(solverScope)
        }
    }

    func runPhases(_ solverScope: SolverScope<Solution_, Score_>) {
        if (!solverScope.getSolutionDescriptor().hasMovableEntities(solverScope.getScoreDirector())) {
            /* WIP: Logger
            logger.info(
                "Skipped all phases ({}): out of {} planning entities, none are movable (non-pinned).",
                phaseList.size(),
                solverScope.getSolutionDescriptor().getEntityCount(solverScope.getWorkingSolution())
            )
             */
            return
        }
        if phaseList.isEmpty {
            return
        }
        var phasesExceptLast = phaseList
        let lastPhase = phasesExceptLast.removeLast()
        
        for phase in phasesExceptLast {
            if self.solverTermination.isSolverTerminated(solverScope) {
                return
            }
            phase.solve(solverScope)
            // If there is a next phase, it starts from the best solution, which might differ from the working solution.
            // If there isn't, no need to planning clone the best solution to the working solution.
            solverScope.setWorkingSolutionFromBestSolution()
        }
        if self.solverTermination.isSolverTerminated(solverScope) {
            return
        }
        lastPhase.solve(solverScope)
    }

    public func solvingEnded(_ solverScope: SolverScope<Solution_, Score_>) {
        for phase in phaseList {
            phase.solvingEnded(solverScope)
        }
        bestSolutionRecaller.solvingEnded(solverScope)
        solverTermination.solvingEnded(solverScope)
        phaseLifecycleSupport.fireSolvingEnded(solverScope)
    }

    public func solvingError(solverScope: SolverScope<Solution_, Score_>, exception: Exception) {
        phaseLifecycleSupport.fireSolvingError(solverScope: solverScope, exception: exception)
        for phase in phaseList {
            phase.solvingError(solverScope: solverScope, exception: exception)
        }
    }

    public func phaseStarted(_ phaseScope: AbstractPhaseScope<Solution_, Score_>) {
        bestSolutionRecaller.phaseStarted(phaseScope)
        phaseLifecycleSupport.firePhaseStarted(phaseScope)
        solverTermination.phaseStarted(phaseScope)
        // Do not propagate to phases; the active phase does that for itself and they should not propagate further.
    }

    public func phaseEnded(_ phaseScope: AbstractPhaseScope<Solution_, Score_>) {
        bestSolutionRecaller.phaseEnded(phaseScope)
        phaseLifecycleSupport.firePhaseEnded(phaseScope)
        solverTermination.phaseEnded(phaseScope)
        // Do not propagate to phases; the active phase does that for itself and they should not propagate further.
    }

    public func stepStarted(_ stepScope: AbstractStepScope<Solution_, Score_>) {
        bestSolutionRecaller.stepStarted(stepScope)
        phaseLifecycleSupport.fireStepStarted(stepScope)
        solverTermination.stepStarted(stepScope)
        // Do not propagate to phases; the active phase does that for itself and they should not propagate further.
    }

    public func stepEnded(_ stepScope: AbstractStepScope<Solution_, Score_>) {
        bestSolutionRecaller.stepEnded(stepScope)
        phaseLifecycleSupport.fireStepEnded(stepScope)
        solverTermination.stepEnded(stepScope)
        // Do not propagate to phases; the active phase does that for itself and they should not propagate further.
    }

    // ************************************************************************
    // Event listeners
    // ************************************************************************

    public func addEventListener(_ eventListener: any SolverEventListener<Solution_>) {
        solverEventSupport.addEventListener(WrappedSolverEventListener(eventListener))
    }

   public func removeEventListener(_ eventListener: any SolverEventListener<Solution_>) {
        solverEventSupport.removeEventListener(WrappedSolverEventListener(eventListener))
    }

    /**
     * Add a {@link PhaseLifecycleListener} that is notified
     * of {@link PhaseLifecycleListener#solvingStarted(SolverScope) solving} events
     * and also of the {@link PhaseLifecycleListener#phaseStarted(AbstractPhaseScope) phase}
     * and the {@link PhaseLifecycleListener#stepStarted(AbstractStepScope) step} starting/ending events of all phases.
     * <p>
     * To get notified for only 1 phase, use {@link Phase#addPhaseLifecycleListener(PhaseLifecycleListener)} instead.
     *
     * @param phaseLifecycleListener never null
     */
    public func addPhaseLifecycleListener(
            _ phaseLifecycleListener: any PhaseLifecycleListener<Solution_, Score_>
    ) {
        phaseLifecycleSupport.addEventListener(WrappedPhaseLifecycleListener(phaseLifecycleListener))
    }

    /**
     * @param phaseLifecycleListener never null
     * @see #addPhaseLifecycleListener(PhaseLifecycleListener)
     */
    public func removePhaseLifecycleListener(
            _ phaseLifecycleListener: any PhaseLifecycleListener<Solution_, Score_>
    ) {
        phaseLifecycleSupport.removeEventListener(WrappedPhaseLifecycleListener(phaseLifecycleListener))
    }

}
