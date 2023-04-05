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
 * A Solver solves a planning problem and returns the best solution found.
 * It's recommended to create a new Solver instance for each dataset.
 * <p>
 * To create a Solver, use {@link SolverFactory#buildSolver()}.
 * To solve a planning problem, call {@link #solve(Object)}.
 * To solve a planning problem without blocking the current thread, use {@link SolverManager} instead.
 * <p>
 * These methods are not thread-safe and should be called from the same thread,
 * except for the methods that are explicitly marked as thread-safe.
 * Note that despite that {@link #solve} is not thread-safe for clients of this class,
 * that method is free to do multithreading inside itself.
 *
 * @param <Solution_> the solution type, the class with the {@link PlanningSolution} annotation
 */
public protocol Solver<Solution_> {
    
    associatedtype Solution_

    /**
     * Solves the planning problem and returns the best solution encountered
     * (which might or might not be optimal, feasible or even initialized).
     * <p>
     * It can take seconds, minutes, even hours or days before this method returns,
     * depending on the termination configuration.
     * To terminate a {@link Solver} early, call {@link #terminateEarly()}.
     *
     * @param problem never null, a {@link PlanningSolution}, usually its planning variables are uninitialized
     * @return never null, but it can return the original, uninitialized {@link PlanningSolution} with a null {@link Score}.
     * @see #terminateEarly()
     */
    func solve(_ problem: Solution_) -> Solution_

    /**
     * Notifies the solver that it should stop at its earliest convenience.
     * This method returns immediately, but it takes an undetermined time
     * for the {@link #solve} to actually return.
     * <p>
     * If the solver is running in daemon mode, this is the only way to terminate it normally.
     * <p>
     * This method is thread-safe.
     * It can only be called from a different thread
     * because the original thread is still calling {@link #solve(Object)}.
     *
     * @return true if successful, false if was already terminating or terminated
     * @see #isTerminateEarly()
     * @see Future#cancel(boolean)
     */
    func terminateEarly() -> Bool

    /**
     * This method is thread-safe.
     *
     * @return true if the {@link #solve} method is still running.
     */
    func isSolving() -> Bool

    /**
     * This method is thread-safe.
     *
     * @return true if terminateEarly has been called since the {@link Solver} started.
     * @see Future#isCancelled()
     */
    func isTerminateEarly() -> Bool

    /**
     * Schedules a {@link ProblemChange} to be processed.
     * <p>
     * As a side effect, this restarts the {@link Solver}, effectively resetting all {@link Termination}s,
     * but not {@link #terminateEarly()}.
     * <p>
     * This method is thread-safe.
     * Follows specifications of {@link BlockingQueue#add(Object)} with by default
     * a capacity of {@link Integer#MAX_VALUE}.
     * <p>
     * To learn more about problem change semantics, please refer to the {@link ProblemChange} Javadoc.
     *
     * @param problemChange never null
     * @see #addProblemChanges(List)
     */
    func addProblemChange(_ problemChange: any ProblemChange<Solution_>)

    /**
     * Schedules multiple {@link ProblemChange}s to be processed.
     * <p>
     * As a side effect, this restarts the {@link Solver}, effectively resetting all {@link Termination}s,
     * but not {@link #terminateEarly()}.
     * <p>
     * This method is thread-safe.
     * Follows specifications of {@link BlockingQueue#add(Object)} with by default
     * a capacity of {@link Integer#MAX_VALUE}.
     * <p>
     * To learn more about problem change semantics, please refer to the {@link ProblemChange} Javadoc.
     *
     * @param problemChangeList never null
     * @see #addProblemChange(ProblemChange)
     */
    @available(macOS 13.0.0, *)
    func addProblemChanges(_ problemChangeList: [any ProblemChange<Solution_>])

    /**
     * Checks if all scheduled {@link ProblemChange}s have been processed.
     * <p>
     * This method is thread-safe.
     *
     * @return true if there are no {@link ProblemChange}s left to do
     */
    func isEveryProblemChangeProcessed() -> Bool

    /**
     * @param eventListener never null
     */
    func addEventListener(_ eventListener: any SolverEventListener<Solution_>)

    /**
     * @param eventListener never null
     */
    func removeEventListener(_ eventListener: any SolverEventListener<Solution_>)

}
