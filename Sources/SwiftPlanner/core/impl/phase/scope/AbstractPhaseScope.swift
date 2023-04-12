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

// WIP: Logger
// WIP: Check time values (i. could be uninitionalized!?; ii. ramifications of using DispatchTime)

/**
 * @param <Solution_> the solution type, the class with the {@link PlanningSolution} annotation
 */
public /*abstract*/ class AbstractPhaseScope<Solution_, Score_ : Score> : JavaStringConvertible {

    // WIP: Logger
    //protected final transient Logger logger = LoggerFactory.getLogger(getClass());

    public let solverScope: SolverScope<Solution_, Score_>
    
    var startingTime: DispatchTime?
    var endingTime: DispatchTime?
    var startingScoreCalculationCount: UInt64?
    var endingScoreCalculationCount: UInt64?
    var startingScore: Score_?
    var childThreadsScoreCalculationCount: UInt64 = 0

    var bestSolutionStepIndex: Int = -1

    public init(solverScope: SolverScope<Solution_, Score_>) {
        self.solverScope = solverScope
    }

    public func getStartingSystemTimeNanos() -> UInt64? {
        return startingTime?.uptimeNanoseconds
    }

    public func getStartingScore() -> Score_? {
        return startingScore
    }

    public func getEndingSystemTimeNanos() -> UInt64? {
        return endingTime?.uptimeNanoseconds
    }

    public /*abstract*/ func getLastCompletedStepScope() -> AbstractStepScope<Solution_, Score_> {
        isAbstractMethod(Self.self)
    }

    // ************************************************************************
    // Calculated methods
    // ************************************************************************

    public func reset() {
        bestSolutionStepIndex = -1
        // TODO Usage of solverScope.getBestScore() would be better performance wise but is null with a uninitialized score
        startingScore = solverScope.calculateScore()
        if (getLastCompletedStepScope().stepIndex < 0) {
            getLastCompletedStepScope().score = startingScore
        }
    }

    public func startingNow() {
        startingTime = DispatchTime.now()
        startingScoreCalculationCount = getScoreDirector().getCalculationCount()
    }

    public func endingNow() {
        endingTime = DispatchTime.now()
        endingScoreCalculationCount = getScoreDirector().getCalculationCount()
    }

    public func getSolutionDescriptor() -> SolutionDescriptor<Solution_, Score_> {
        return solverScope.getSolutionDescriptor()
    }

    public func calculateSolverTimeNanossSpentUpToNow() -> UInt64 {
        return solverScope.calculateTimeNanosSpentUpToNow()
    }

    public func calculatePhaseTimeNanosSpentUpToNow() -> UInt64 {
        guard let startingSystemTimeNanos = startingTime?.uptimeNanoseconds else {
            return illegalState("startingNow has to be called before this method!")
        }
        let now = DispatchTime.now().uptimeNanoseconds
        return now - startingSystemTimeNanos
    }

    public func getPhaseTimeNanosSpent() -> UInt64 {
        guard let startingSystemTimeNanos = startingTime?.uptimeNanoseconds,
              let endingSystemTimeNanos = endingTime?.uptimeNanoseconds else {
            return illegalState("startingNow and endingNow have to be called before this method!")
        }
        return endingSystemTimeNanos - startingSystemTimeNanos
    }

    public func addChildThreadsScoreCalculationCount(_ addition: UInt64) {
        solverScope.addChildThreadsScoreCalculationCount(addition)
        childThreadsScoreCalculationCount += addition
    }

    public func getPhaseScoreCalculationCount() -> UInt64 {
        guard let endingScoreCalculationCount = endingScoreCalculationCount,
              let startingScoreCalculationCount = startingScoreCalculationCount else {
            return illegalState("startingNow and endingNow have to be called before this method!")
        }
        return endingScoreCalculationCount - startingScoreCalculationCount
            + childThreadsScoreCalculationCount
    }

    /**
     * @return at least 0, per second
     */
    public func getPhaseScoreCalculationSpeed() -> UInt64 {
        let timeNanosSpent = getPhaseTimeNanosSpent();
        // Avoid divide by zero exception on a fast CPU
        return getPhaseScoreCalculationCount() * 1000000000
            / (timeNanosSpent == 0 ? 1 : timeNanosSpent)
    }

    public func getScoreDirector() -> any InnerScoreDirector<Solution_, Score_> {
        return solverScope.getScoreDirector()
    }

    public func getWorkingSolution() -> Solution_ {
        return solverScope.getWorkingSolution()
    }

    @available(macOS 13.0.0, *)
    public func getWorkingEntityCount() -> Int {
        return solverScope.getWorkingEntityCount()
    }

    public func getWorkingValueCount() -> Int {
        return solverScope.getWorkingValueCount()
    }

    public func calculateScore() -> Score_ {
        return solverScope.calculateScore()
    }

    public func assertExpectedWorkingScore(
            expectedWorkingScore: Score_,
            completedAction: CustomStringConvertible?
    ) {
        getScoreDirector().assertExpectedWorkingScore(
            expectedWorkingScore,
            completedAction: completedAction
        )
    }

    public func assertWorkingScoreFromScratch(
            _ workingScore: Score_,
            completedAction: CustomStringConvertible?
    ) {
        getScoreDirector().assertWorkingScoreFromScratch(
            workingScore,
            completedAction: completedAction
        )
    }

    public func assertPredictedScoreFromScratch(
            workingScore: Score_,
            completedAction: CustomStringConvertible?
    ) {
        getScoreDirector().assertPredictedScoreFromScratch(
            workingScore,
            completedAction: completedAction
        )
    }

    public func assertShadowVariablesAreNotStale(
            workingScore: Score_,
            completedAction: CustomStringConvertible?
    ) {
        getScoreDirector().assertShadowVariablesAreNotStale(
            expectedWorkingScore: workingScore,
            completedAction: completedAction
        )
    }

    public func getWorkingRandom() -> RandomNumberGenerator {
        return solverScope.getWorkingRandom()
    }

    public func isBestSolutionInitialized() -> Bool {
        return solverScope.isBestSolutionInitialized()
    }

    public func getBestScore() -> Score_? {
        return solverScope.getBestScore()
    }

    public func getPhaseBestSolutionTimeNanos() -> UInt64 {
        guard let bestSolutionTimeNanos = solverScope.getBestSolutionTimeNanos() else {
            return illegalState("solver scope best solution time not yet initialized!")
        }
        guard let startingSystemTimeNanos = startingTime?.uptimeNanoseconds else {
            return illegalState("startingNow has to be called before this method!")
        }
        // If the termination is explicitly phase configured, previous phases must not affect it
        return max(bestSolutionTimeNanos, startingSystemTimeNanos)
    }

    public func getNextStepIndex() -> Int {
        return getLastCompletedStepScope().stepIndex + 1
    }

    public func toString() -> String {
        return String(describing: Self.self) // TODO add + "(" + phaseIndex + ")"
    }

}
