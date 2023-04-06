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

/* WIP: requires SolutionDescriptor for
        getSolutionDescriptor, getWorkingEntityCount, getWorkingValueCount
 */
/*
 WIP: Check whether parts with Semaphore are needed:
      runnableThreadSemaphore, setRunnableThreadSemaphore,
      initializeYielding, checkYielding, destroyYielding
 */

// WIP: Check for parameterless init (see createChildThreadSolverScope)

/**
 * @param <Solution_> the solution type, the class with the {@link PlanningSolution} annotation
 */
public class SolverScope<Solution_, Score_ : Score> {
    
    var solverMetricSet: Set<SolverMetric<Solution_>> = []
    var monitoringTags: Tags
    var startingSolverCount: Int = 0
    var workingRandom: RandomNumberGenerator
    var scoreDirector: any InnerScoreDirector<Solution_, Score_>
    private var problemChangeDirector: DefaultProblemChangeDirector<Solution_>
    
    /*
    /**
     * Used for capping CPU power usage in multithreaded scenarios.
     */
    protected Semaphore runnableThreadSemaphore = null;
     */

    // WIP: Check volatile attributes
    /*volatile*/ var startingTime: DispatchTime?
    /*volatile*/ var endingTime: DispatchTime?
    var childThreadsScoreCalculationCount: UInt64 = 0

    public var startingInitializedScore: Score_?

    /*volatile*/ var bestSolution: Solution_?
    /*volatile*/ var bestScore: Score_?
    var bestSolutionTime: DispatchTime?
    
    /**
     * Used for tracking step score
     */
    let stepScoreMap: [Tags:[AtomicReference<Number>]] = [:] // WIP: concurrent

    // ************************************************************************
    // Constructors and simple getters/setters
    // ************************************************************************
    
    init(
            monitoringTags: Tags,
            workingRandom: RandomNumberGenerator,
            scoreDirector: any InnerScoreDirector<Solution_, Score_>,
            problemChangeDirector: DefaultProblemChangeDirector<Solution_>
    ) {
        self.monitoringTags = monitoringTags
        self.workingRandom = workingRandom
        self.scoreDirector = scoreDirector
        self.problemChangeDirector = problemChangeDirector
    }

    public func getProblemChangeDirector() -> DefaultProblemChangeDirector<Solution_> {
        return problemChangeDirector
    }

    public func setProblemChangeDirector(
            _ problemChangeDirector: DefaultProblemChangeDirector<Solution_>
    ) {
        self.problemChangeDirector = problemChangeDirector
    }

    public func getMonitoringTags() -> Tags {
        return monitoringTags
    }

    public func setMonitoringTags(_ monitoringTags: Tags) {
        self.monitoringTags = monitoringTags
    }

    public func getStepScoreMap() -> [Tags:[AtomicReference<Number>]] {
        return stepScoreMap
    }

    public func getSolverMetricSet() -> Set<SolverMetric<Solution_>> {
        return solverMetricSet
    }

    public func setSolverMetricSet(_ solverMetricSet: Set<SolverMetric<Solution_>>) {
        self.solverMetricSet = solverMetricSet
    }

    public func getStartingSolverCount() -> Int {
        return startingSolverCount
    }

    public func setStartingSolverCount(_ startingSolverCount: Int) {
        self.startingSolverCount = startingSolverCount
    }

    public func getWorkingRandom() -> RandomNumberGenerator {
        return workingRandom
    }

    public func setWorkingRandom(_ workingRandom: RandomNumberGenerator) {
        self.workingRandom = workingRandom
    }

    public func getScoreDirector() -> any InnerScoreDirector<Solution_, Score_> {
        return scoreDirector
    }

    public func setScoreDirector(_ scoreDirector: some InnerScoreDirector<Solution_, Score_>) {
        self.scoreDirector = scoreDirector
    }
    /*
    public func setRunnableThreadSemaphore(runnableThreadSemaphore: Semaphore) {
        self.runnableThreadSemaphore = runnableThreadSemaphore
    }*/
     
    public func getStartingSystemTimeNanos() -> UInt64? {
        return startingTime?.uptimeNanoseconds
    }

    public func getEndingSystemTimeNanos() -> UInt64? {
        return endingTime?.uptimeNanoseconds
    }
    
    public func getSolutionDescriptor() -> SolutionDescriptor<Solution_> {
        return scoreDirector.getSolutionDescriptor()
    }

    public func getScoreDefinition() -> any ScoreDefinition<Score_> {
        return scoreDirector.getScoreDefinition()
    }

    public func getWorkingSolution() -> Solution_ {
        return scoreDirector.getWorkingSolution()
    }
    /*
    public func getWorkingEntityCount() -> Int {
        return getSolutionDescriptor().getEntityCount(getWorkingSolution())
    }

    public func getWorkingValueCount() -> Int {
        return getSolutionDescriptor().getValueCount(getWorkingSolution())
    }*/

    public func calculateScore() -> Score_ {
        return scoreDirector.calculateScore()
    }

    public func assertScoreFromScratch(solution: Solution_) {
        scoreDirector.getScoreDirectorFactory().assertScoreFromScratch(solution: solution)
    }

    public func addChildThreadsScoreCalculationCount(_ addition: UInt64) {
        childThreadsScoreCalculationCount += addition
    }

    public func getScoreCalculationCount() -> UInt64 {
        return scoreDirector.getCalculationCount() + childThreadsScoreCalculationCount
    }

    public func getBestSolution() -> Solution_? {
        return bestSolution
    }

    /**
     * The {@link PlanningSolution best solution} must never be the same instance
     * as the {@link PlanningSolution working solution}, it should be a (un)changed clone.
     *
     * @param bestSolution never null
     */
    public func setBestSolution(_ bestSolution: Solution_) {
        self.bestSolution = bestSolution
    }

    public func getBestScore() -> Score_? {
        return bestScore
    }

    public func setBestScore(_ bestScore: Score_) {
        self.bestScore = bestScore
    }

    public func getBestSolutionTimeNanos() -> UInt64? {
        return bestSolutionTime?.uptimeNanoseconds
    }

    public func setBestSolutionTime(_ bestSolutionTime: DispatchTime) {
        self.bestSolutionTime = bestSolutionTime
    }

    // ************************************************************************
    // Calculated methods
    // ************************************************************************

    public func isMetricEnabled(_ solverMetric: SolverMetric<Solution_>) -> Bool {
        return solverMetricSet.contains(solverMetric)
    }

    public func startingNow() {
        startingTime = DispatchTime.now()
        endingTime = nil
    }

    /// Must not be called before `startingNow` has been called.
    public func getBestSolutionTimeNanosSpent() -> UInt64 {
        guard let bestSolutionTimeNanos = bestSolutionTime?.uptimeNanoseconds else {
            return illegalState("setBestSolutionTime method has to be called before this method!")
        }
        guard let startingTimeNanos = startingTime?.uptimeNanoseconds else {
            return illegalState("startingNow method has to be called before this method!")
        }
        return bestSolutionTimeNanos - startingTimeNanos
    }

    public func endingNow() {
        endingTime = DispatchTime.now()
    }

    public func isBestSolutionInitialized() -> Bool {
        return bestScore?.isSolutionInitialized() ?? false
    }

    public func calculateTimeNanosSpentUpToNow() -> UInt64 {
        let now = DispatchTime.now()
        guard let startingTimeNanos = startingTime?.uptimeNanoseconds else {
            return illegalState("startingNow method has to be called before this method!")
        }
        return now.uptimeNanoseconds - startingTimeNanos
    }

    public func getTimeNanosSpent() -> UInt64 {
        guard let endingTimeNanos = endingTime?.uptimeNanoseconds else {
            return illegalState("endingNow method has to be called before this method!")
        }
        guard let startingTimeNanos = startingTime?.uptimeNanoseconds else {
            return illegalState("startingNow method has to be called before this method!")
        }
        return endingTimeNanos - startingTimeNanos
    }

    /**
     * @return at least 0, per second
     */
    public func getScoreCalculationSpeed() -> UInt64 {
        let timeNanosSpent = getTimeNanosSpent()
        // Avoid divide by zero exception on a fast CPU
        return getScoreCalculationCount() * 1000000000 / (timeNanosSpent == 0 ? 1 : timeNanosSpent)
    }

    public func setWorkingSolutionFromBestSolution() {
        guard let bestSolution = bestSolution else {
            return illegalState("bestSolution has to be set before calling this method!")
        }
        // The workingSolution must never be the same instance as the bestSolution.
        scoreDirector.setWorkingSolution(workingSolution: scoreDirector.cloneSolution(bestSolution))
    }

    public func createChildThreadSolverScope(
            _ childThreadType: ChildThreadType
    ) -> SolverScope {
        // WIP: Check for parameter-less init.
        let childThreadSolverScope = SolverScope(
            monitoringTags: monitoringTags,
            workingRandom: RandomNumberGeneratorWithSeed(workingRandom.next()),
            scoreDirector: scoreDirector.createChildThreadScoreDirector(
                type: childThreadType
            ),
            problemChangeDirector: problemChangeDirector
        )
        childThreadSolverScope.monitoringTags = monitoringTags
        childThreadSolverScope.solverMetricSet = solverMetricSet
        childThreadSolverScope.startingSolverCount = startingSolverCount
        
        // WIP: Check whether these comments from original engine still apply.
        // TODO FIXME use RandomFactory
        // Experiments show that this trick to attain reproducibility doesn't break uniform distribution
        childThreadSolverScope.workingRandom = RandomNumberGeneratorWithSeed(workingRandom.next())
        
        childThreadSolverScope.scoreDirector = scoreDirector.createChildThreadScoreDirector(
            type: childThreadType
        )
        childThreadSolverScope.startingTime = startingTime
        childThreadSolverScope.endingTime = nil
        childThreadSolverScope.startingInitializedScore = nil
        childThreadSolverScope.bestSolution = nil
        childThreadSolverScope.bestScore = nil
        childThreadSolverScope.bestSolutionTime = nil
        return childThreadSolverScope
    }

}
