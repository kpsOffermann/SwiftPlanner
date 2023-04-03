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

// WIP: Implement the cases (as static let)

public final class SolverMetric<Solution_> : HashableByIdentity {
    
    /*
    SOLVE_DURATION("optaplanner.solver.solve.duration", false),
    ERROR_COUNT("optaplanner.solver.errors", false),
    BEST_SCORE("optaplanner.solver.best.score", new BestScoreStatistic<>(), true),
    STEP_SCORE("optaplanner.solver.step.score", false),
    SCORE_CALCULATION_COUNT("optaplanner.solver.score.calculation.count", false),
    BEST_SOLUTION_MUTATION("optaplanner.solver.best.solution.mutation", new BestSolutionMutationCountStatistic<>(), true),
    MOVE_COUNT_PER_STEP("optaplanner.solver.step.move.count", false),
    MEMORY_USE("jvm.memory.used", new MemoryUseStatistic<>(), false),
    CONSTRAINT_MATCH_TOTAL_BEST_SCORE("optaplanner.solver.constraint.match.best.score", true),
    CONSTRAINT_MATCH_TOTAL_STEP_SCORE("optaplanner.solver.constraint.match.step.score", false),
    PICKED_MOVE_TYPE_BEST_SCORE_DIFF("optaplanner.solver.move.type.best.score.diff", new PickedMoveBestScoreDiffStatistic<>(),
            true),
    PICKED_MOVE_TYPE_STEP_SCORE_DIFF("optaplanner.solver.move.type.step.score.diff", new PickedMoveStepScoreDiffStatistic<>(),
            false);
     */

    private let meterId: String
    
    private let registerFunction: any SolverStatistic<Solution_>
    private let isBestSolutionBased: Bool

    private convenience init(meterId: String, isBestSolutionBased: Bool) {
        self.init(
            meterId: meterId,
            registerFunction: StatelessSolverStatistic<Solution_>(),
            isBestSolutionBased: isBestSolutionBased
        )
    }

    private init(
            meterId: String,
            registerFunction: some SolverStatistic<Solution_>,
            isBestSolutionBased: Bool
    ) {
        self.meterId = meterId
        self.registerFunction = registerFunction
        self.isBestSolutionBased = isBestSolutionBased
    }

    public func getMeterId() -> String {
        return meterId
    }

    public static func registerScoreMetrics(
            metric: SolverMetric,
            tags: Tags,
            scoreDefinition: any ScoreDefinition,
            tagToScoreLevels: inout [Tags:[AtomicReference<Number>]],
            score: any Score
    ) {
        let levelValues = score.toLevelNumbers()
        if let scoreLevels = tagToScoreLevels[tags] {
            for (scoreLevel, levelValue) in zip(scoreLevels, levelValues) {
                scoreLevel.set(levelValue)
            }
        } else {
            let levelLabels = scoreDefinition.getLevelLabels().map({
                $0.replacingOccurrences(of: " ", with: ".")
            })
            var scoreLevels = [AtomicReference<Number>]()
            for (levelLabel, levelValue) in zip(levelLabels, levelValues) {
                scoreLevels.append(
                    Metrics.gauge(
                        name: metric.getMeterId() + "." + levelLabel,
                        tags: tags,
                        value: AtomicReference(levelValue),
                        valueFunction: { $0.get().toDouble() }
                    )
                )
            }
            tagToScoreLevels[tags] = scoreLevels
        }
    }

    public func isMetricBestSolutionBased() -> Bool {
        return isBestSolutionBased;
    }

    public func register(solver: any Solver<Solution_>) {
        registerFunction.register(solver: solver)
    }

    public func unregister(solver: any Solver<Solution_>) {
        registerFunction.unregister(solver: solver)
    }
    
}
