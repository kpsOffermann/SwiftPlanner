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

import Foundation

// WIP: Logger (from AbstractSolver)

// WIP: Check support for adding exceptions to method solve

/**
 * Default implementation for {@link Solver}.
 *
 * @param <Solution_> the solution type, the class with the {@link PlanningSolution} annotation
 * @see Solver
 * @see AbstractSolver
 */
@available(macOS 13.0.0, *)
public class DefaultSolver<Solution_, Score_ : Score> : AbstractSolver<Solution_, Score_> {

    public internal(set) var environmentMode: EnvironmentMode
        
    public internal(set) var randomFactory: RandomFactory

    var basicPlumbingTermination: BasicPlumbingTermination<Solution_, Score_>

    let solving = AtomicBoolean(false)

    public let solverScope: SolverScope<Solution_, Score_>

    private let moveThreadCountDescription: String

    // ************************************************************************
    // Constructors and simple getters/setters
    // ************************************************************************

    public init(
            environmentMode: EnvironmentMode,
            randomFactory: RandomFactory,
            bestSolutionRecaller: BestSolutionRecaller<
                Solution_,
                Score_,
                WrappedSolverEventListener<Solution_>
            >,
            basicPlumbingTermination: BasicPlumbingTermination<Solution_, Score_>,
            termination: any Termination<Solution_, Score_>,
            phaseList: [any Phase<Solution_, Score_>],
            solverScope: SolverScope<Solution_, Score_>,
            moveThreadCountDescription: String
    ) {
        self.environmentMode = environmentMode
        self.randomFactory = randomFactory
        self.basicPlumbingTermination = basicPlumbingTermination
        self.solverScope = solverScope
        self.moveThreadCountDescription = moveThreadCountDescription
        super.init(
            bestSolutionRecaller: bestSolutionRecaller,
            solverTermination: termination,
            phaseList: phaseList
        )
    }

    public func getScoreDirectorFactory() -> any InnerScoreDirectorFactory<Solution_, Score_> {
        return solverScope.getScoreDirector().getScoreDirectorFactory()
    }

    // ************************************************************************
    // Complex getters
    // ************************************************************************

    public func getTimeNanosSpent() -> UInt64 {
        guard let startingSystemTimeNanos = solverScope.getStartingSystemTimeNanos() else {
            // The solver hasn't started yet
            return 0
        }
        let endingSystemTimeNanos = solverScope.getEndingSystemTimeNanos()
            // The solver hasn't ended yet
            ?? DispatchTime.now().uptimeNanoseconds
        return endingSystemTimeNanos - startingSystemTimeNanos
    }

    public func isSolving() -> Bool {
        return solving.get()
    }

    public func terminateEarly() async -> Bool {
        let terminationEarlySuccessful = await basicPlumbingTermination.terminateEarly()
    /* WIP: Logger
        if terminationEarlySuccessful {
            logger.info("Terminating solver early.")
        }
     */
        return terminationEarlySuccessful
    }

    public func isTerminateEarly() -> Bool {
        return basicPlumbingTermination.isTerminateEarly()
    }

    public func addProblemChange(_ problemChange: any ProblemChange<Solution_>) {
        _ = basicPlumbingTermination.addProblemChange(problemChange.adapter())
    }

    public func addProblemChanges(_ problemChangeList: [any ProblemChange<Solution_>]) {
        problemChangeList.forEach(addProblemChange)
    }

    public func isEveryProblemChangeProcessed() -> Bool {
        return basicPlumbingTermination.isEveryProblemFactChangeProcessed()
    }

    public func setMonitorTagMap(_ monitorTagMap: [String:String]) {
        let monitoringTags = monitorTagMap.map(Tags.of).reduce(Tags.empty(), Tags.and)
        solverScope.setMonitoringTags(monitoringTags)
    }

    // ************************************************************************
    // Worker methods
    // ************************************************************************
    
    public final func solve(_ problem: Solution_) async -> Solution_ {
        // No tags for these metrics; they are global
        let solveLengthTimer: LongTaskTimer = Metrics.more().longTaskTimer(
            name: SolverMetric<Solution_>.SOLVE_DURATION.getMeterId()
        )
        /* WIP: Exceptions
        let errorCounter = Metrics.counter(name: SolverMetric<Solution_>.ERROR_COUNT.getMeterId())
         */

        // Score Calculation Count is specific per solver
        _ = Metrics.gauge(
            name: SolverMetric<Solution_>.SCORE_CALCULATION_COUNT.getMeterId(),
            tags: solverScope.getMonitoringTags(),
            value: solverScope,
            valueFunction: { Double($0.getScoreCalculationCount()) }
        )
        for solverMetric in solverScope.getSolverMetricSet() {
            solverMetric.register(self)
        }

        solverScope.setBestSolution(problem)
        outerSolvingStarted(solverScope)
        var restartSolver = true
        while restartSolver {
            let sample: LongTaskTimer.Sample = solveLengthTimer.start()
            // do {
                solvingStarted(solverScope)
                runPhases(solverScope)
                solvingEnded(solverScope)
        /* WIP: Exceptions
            } catch (Exception e) {
                errorCounter.increment();
                solvingError(solverScope, e);
                throw e;
            } finally {
         */
                _ = sample.stop()
                _ = Metrics.globalRegistry.remove(
                    Meter.Id(
                        name: SolverMetric<Solution_>.SCORE_CALCULATION_COUNT.getMeterId(),
                        tags: solverScope.getMonitoringTags(),
                        baseUnit: nil,
                        description: nil,
                        type: MeterType.GAUGE
                    )
                )
                for solverMetric in solverScope.getSolverMetricSet() {
                    solverMetric.unregister(self)
                }
            //}
            restartSolver = await checkProblemFactChanges()
        }
        outerSolvingEnded(solverScope)
        return solverScope.getBestSolution() ?? illegalState(
            "solver scope's best solution still not initialized at end of solving process!"
        )
    }

    public func outerSolvingStarted(_ solverScope: SolverScope<Solution_, Score_>) {
        solving.set(true)
        basicPlumbingTermination.resetTerminateEarly()
        solverScope.setStartingSolverCount(0)
        solverScope.setWorkingRandom(randomFactory.createRandom())
    }

    public override func solvingStarted(_ solverScope: SolverScope<Solution_, Score_>) {
        solverScope.startingNow()
        solverScope.getScoreDirector().resetCalculationCount()
        super.solvingStarted(solverScope)
        let startingSolverCount = solverScope.getStartingSolverCount() + 1
        solverScope.setStartingSolverCount(startingSolverCount)
    /* WIP: Logger
        logger.info(
            "Solving {}: time spent ({}), best score ({}), environment mode ({}), "
                + "move thread count ({}), random ({}).",
            (startingSolverCount == 1 ? "started" : "restarted"),
            solverScope.calculateTimeNanosSpentUpToNow(),
            solverScope.getBestScore(),
            environmentMode.name(),
            moveThreadCountDescription,
            randomFactory ?? "not fixed"
        )
     */
    }

    public override func solvingEnded(_ solverScope: SolverScope<Solution_, Score_>) {
        super.solvingEnded(solverScope)
        solverScope.endingNow()
    }

    public func outerSolvingEnded(_ solverScope: SolverScope<Solution_, Score_>) {
        // Must be kept open for doProblemFactChange
        solverScope.getScoreDirector().close()
    /* WIP: Logger
        logger.info(
            "Solving ended: time spent ({}), best score ({}), score calculation speed ({}/sec), "
                + "phase total ({}), environment mode ({}), move thread count ({}).",
            solverScope.getTimeNanosSpent(),
            solverScope.getBestScore(),
            solverScope.getScoreCalculationSpeed(),
            phaseList.size(),
            environmentMode.name(),
            moveThreadCountDescription
        )
        solving.set(false)
     */
    }

    private func checkProblemFactChanges() async -> Bool {
        guard await basicPlumbingTermination.waitForRestartSolverDecision() else {
            return false
        }
        let problemFactChangeQueue = basicPlumbingTermination.startProblemFactChangesProcessing()
        solverScope.setWorkingSolutionFromBestSolution()

        var stepIndex = 0
        var problemChangeAdapter = problemFactChangeQueue.poll();
        while (problemChangeAdapter != nil) {
            problemChangeAdapter?(solverScope)
        /* WIP: Logger
            logger.debug("    Real-time problem change applied; step index ({}).", stepIndex)
         */
            stepIndex += 1
            problemChangeAdapter = problemFactChangeQueue.poll()
        }
        // All PFCs are processed, fail fast if any of the new facts have null planning IDs.
        let scoreDirector = solverScope.getScoreDirector()
        scoreDirector.assertNonNullPlanningIds()
        // Everything is fine, proceed.
        basicPlumbingTermination.endProblemFactChangesProcessing()
        bestSolutionRecaller.updateBestSolutionAndFireIfInitialized(solverScope)
    /* WIP: Logger
        // WIP: Check whether the change in ordering of statements had any repurcussions
        let score = scoreDirector.calculateScore()
        logger.info(
            "Real-time problem fact changes done: step total ({}), new best score ({}).",
            stepIndex,
            score
        )
     */
        return true
    }
    
}
