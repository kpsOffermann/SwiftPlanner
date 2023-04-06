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

/**
 * Remembers the {@link PlanningSolution best solution} that a {@link Solver} encounters.
 *
 * @param <Solution_> the solution type, the class with the {@link PlanningSolution} annotation
 */
public class BestSolutionRecaller<
        Solution_,
        Score_ : Score,
        Listener_ : SolverEventListener<Solution_>
> : PhaseLifecycleListenerAdapter<Solution_, Score_> {

    public var assertInitialScoreFromScratch = false
    public var assertShadowVariablesAreNotStale = false
    public var assertBestScoreIsUnmodified = false

    var solverEventSupport: SolverEventSupport<Solution_, Listener_>?
    
    public func setSolverEventSupport(_ solverEventSupport: SolverEventSupport<Solution_, Listener_>) {
        self.solverEventSupport = solverEventSupport
    }
    
    private func getSolverEventSupport() -> SolverEventSupport<Solution_, Listener_> {
        return solverEventSupport
            ?? illegalState("setSolverEventSupport has to be called before this method!")
    }
    
    private func getBestSolution(_ solverScope: SolverScope<Solution_, Score_>) -> Solution_ {
        return solverScope.getBestSolution()
            ?? illegalState("solver scope's best solution is not yet initialized!")
    }
    
    private func getBestScore(_ solverScope: SolverScope<Solution_, Score_>) -> Score_ {
        return solverScope.getBestScore()
            ?? illegalState("solver scope's best score is not yet initialized!")
    }
    
    private func getScore(_ stepScope: AbstractStepScope<Solution_, Score_>) -> Score_ {
        return stepScope.score
            ?? illegalState("step scope's score is not yet initialized!")
    }

    // ************************************************************************
    // Worker methods
    // ************************************************************************

    public override func solvingStarted(_ solverScope: SolverScope<Solution_, Score_>) {
        // Starting bestSolution is already set by Solver.solve(Solution)
        let scoreDirector = solverScope.getScoreDirector()
        let score = scoreDirector.calculateScore()
        solverScope.setBestScore(score)
        solverScope.setBestSolutionTime(DispatchTime.now())
        // The original bestSolution might be the final bestSolution and should have an accurate Score
        solverScope.getSolutionDescriptor().setScore(
            solution: getBestSolution(solverScope),
            score: score
        )
        solverScope.startingInitializedScore = score.isSolutionInitialized() ? score : nil
        if (assertInitialScoreFromScratch) {
            scoreDirector.assertWorkingScoreFromScratch(
                score,
                completedAction: "Initial score calculated"
            )
        }
        if (assertShadowVariablesAreNotStale) {
            scoreDirector.assertShadowVariablesAreNotStale(
                expectedWorkingScore: score,
                completedAction: "Initial score calculated"
            )
        }
    }

    public func processWorkingSolutionDuringConstructionHeuristicsStep(
            _ stepScope: AbstractStepScope<Solution_, Score_>
    ) {
        let phaseScope = stepScope.getPhaseScope()
        let solverScope = phaseScope.solverScope
        stepScope.bestScoreImproved = true
        phaseScope.bestSolutionStepIndex = stepScope.stepIndex
        let newBestSolution = stepScope.getWorkingSolution()
        // Construction heuristics don't fire intermediate best solution changed events.
        // But the best solution and score are updated, so that unimproved* terminations work correctly.
        updateBestSolutionWithoutFiring(
            solverScope: solverScope,
            bestScore: getScore(stepScope),
            bestSolution: newBestSolution
        )
    }

    @available(macOS 13.0.0, *)
    public func processWorkingSolutionDuringStep(_ stepScope: AbstractStepScope<Solution_, Score_>) {
        let phaseScope = stepScope.getPhaseScope()
        let score = getScore(stepScope)
        let solverScope = phaseScope.solverScope
        let bestScoreImproved = score.compareTo(getBestScore(solverScope)) > 0
        stepScope.bestScoreImproved = bestScoreImproved
        if (bestScoreImproved) {
            phaseScope.bestSolutionStepIndex = stepScope.stepIndex
            let newBestSolution = stepScope.createOrGetClonedSolution()
            updateBestSolutionAndFire(solverScope, bestScore: score, bestSolution: newBestSolution)
        } else if (assertBestScoreIsUnmodified) {
            solverScope.assertScoreFromScratch(solution: getBestSolution(solverScope))
        }
    }

    @available(macOS 13.0.0, *)
    public func processWorkingSolutionDuringMove(
            score: Score_,
            stepScope: AbstractStepScope<Solution_, Score_>
    ) {
        let phaseScope = stepScope.getPhaseScope()
        let solverScope = phaseScope.solverScope
        let bestScoreImproved = score.compareTo(getBestScore(solverScope)) > 0
        // The method processWorkingSolutionDuringMove() is called 0..* times
        // stepScope.getBestScoreImproved() is initialized on false before the first call here
        if (bestScoreImproved) {
            stepScope.bestScoreImproved = bestScoreImproved
        }
        if (bestScoreImproved) {
            phaseScope.bestSolutionStepIndex = stepScope.stepIndex
            let newBestSolution = solverScope.getScoreDirector().cloneWorkingSolution()
            updateBestSolutionAndFire(solverScope, bestScore: score, bestSolution: newBestSolution)
        } else if (assertBestScoreIsUnmodified) {
            solverScope.assertScoreFromScratch(solution: getBestSolution(solverScope))
        }
    }

    @available(macOS 13.0.0, *)
    public func updateBestSolutionAndFire(_ solverScope: SolverScope<Solution_, Score_>) {
        updateBestSolutionWithoutFiring(solverScope)
        getSolverEventSupport().fireBestSolutionChanged(
            solverScope: solverScope,
            newBestSolution: getBestSolution(solverScope)
        )
    }

    @available(macOS 13.0.0, *)
    public func updateBestSolutionAndFireIfInitialized(
            _ solverScope: SolverScope<Solution_, Score_>
    ) {
        updateBestSolutionWithoutFiring(solverScope)
        if (solverScope.isBestSolutionInitialized()) {
            getSolverEventSupport().fireBestSolutionChanged(
                solverScope: solverScope,
                newBestSolution: getBestSolution(solverScope)
            )
        }
    }

    @available(macOS 13.0.0, *)
    private func updateBestSolutionAndFire(
            _ solverScope: SolverScope<Solution_, Score_>,
            bestScore: Score_,
            bestSolution: Solution_
    ) {
        updateBestSolutionWithoutFiring(
            solverScope: solverScope,
            bestScore: bestScore,
            bestSolution: bestSolution
        )
        getSolverEventSupport().fireBestSolutionChanged(
            solverScope: solverScope,
            newBestSolution: getBestSolution(solverScope)
        )
    }

    private func updateBestSolutionWithoutFiring(_ solverScope: SolverScope<Solution_, Score_>) {
        let newBestSolution = solverScope.getScoreDirector().cloneWorkingSolution()
        guard let newBestScore = solverScope.getSolutionDescriptor().getScore(newBestSolution) as? Score_ else {
            return illegalState("score of solver scope's solution descriptor is uninitialized")
        }
        updateBestSolutionWithoutFiring(
            solverScope: solverScope,
            bestScore: newBestScore,
            bestSolution: newBestSolution
        )
    }

    private func updateBestSolutionWithoutFiring(
            solverScope: SolverScope<Solution_, Score_>,
            bestScore: Score_,
            bestSolution: Solution_
    ) {
        if (bestScore.isSolutionInitialized()) {
            if (!solverScope.isBestSolutionInitialized()) {
                solverScope.startingInitializedScore = bestScore
            }
        }
        solverScope.setBestSolution(bestSolution)
        solverScope.setBestScore(bestScore)
        solverScope.setBestSolutionTime(DispatchTime.now())
    }

}
