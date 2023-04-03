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

// WIP: Features of EventObject

/**
 * Delivered when the {@link PlanningSolution best solution} changes during solving.
 * Delivered in the solver thread (which is the thread that calls {@link Solver#solve}).
 *
 * @param <Solution_> the solution type, the class with the {@link PlanningSolution} annotation
 */
public class BestSolutionChangedEvent<Solution_> /*: EventObject*/ {

    private let solver: any Solver<Solution_>
    private let timeNanosSpent: UInt64
    private let newBestSolution: Solution_
    private let newBestScore: any Score

    /**
     * @param solver never null
     * @param timeNanosSpent {@code >= 0L}
     * @param newBestSolution never null
     */
    public init(
            solver: some Solver<Solution_>,
            timeNanosSpent: UInt64,
            newBestSolution: Solution_,
            newBestScore: any Score
    ) {
        //super(solver)
        self.solver = solver
        self.timeNanosSpent = timeNanosSpent
        self.newBestSolution = newBestSolution
        self.newBestScore = newBestScore
    }

    /**
     * @return {@code >= 0}, the amount of nanos spent since the {@link Solver} started
     *         until {@link #getNewBestSolution()} was found
     */
    public func getTimeNanosSpent() -> UInt64 {
        return timeNanosSpent;
    }

    /**
     * Note that:
     * <ul>
     * <li>In real-time planning, not all {@link ProblemChange}s might be processed:
     * check {@link #isEveryProblemFactChangeProcessed()}.</li>
     * <li>this {@link PlanningSolution} might be uninitialized: check {@link Score#isSolutionInitialized()}.</li>
     * <li>this {@link PlanningSolution} might be infeasible: check {@link Score#isFeasible()}.</li>
     * </ul>
     *
     * @return never null
     */
    public func getNewBestSolution() -> Solution_ {
        return newBestSolution
    }

    /**
     * Returns the {@link Score} of the {@link #getNewBestSolution()}.
     * <p>
     * This is useful for generic code, which doesn't know the type of the {@link PlanningSolution}
     * to retrieve the {@link Score} from the {@link #getNewBestSolution()} easily.
     *
     * @return never null, because at this point it's always already calculated
     */
    public func getNewBestScore() -> any Score {
        return newBestScore
    }

    /**
     * @return As defined by {@link Solver#isEveryProblemChangeProcessed()}
     * @see Solver#isEveryProblemChangeProcessed()
     */
    public func isEveryProblemChangeProcessed() -> Bool {
        return solver.isEveryProblemChangeProcessed()
    }

}
