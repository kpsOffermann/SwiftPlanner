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

// WIP: synchronized, (will be implemented once class gets used) see e.g. actors or  https://stackoverflow.com/questions/24045895/what-is-the-swift-equivalent-to-objective-cs-synchronized
// WIP: Logger (isSolverTerminated)

public typealias ProblemChangeAdapter<
        Solution_ : PlanningSolution,
        Score_ : Score
> = (SolverScope<Solution_, Score_>) -> Void

/**
 * Concurrency notes:
 * Condition predicate on ({@link #problemFactChangeQueue} is not empty or {@link #terminatedEarly} is true).
 */
@available(macOS 10.15.0, *)
public class BasicPlumbingTermination<
        Solution_ : PlanningSolution,
        Score_ : Score
> : PhaseLifecycleListenerAdapter<Solution_, Score_>, Termination, JavaStringConvertible {
    
    /* WIP: Logger
    protected final transient Logger logger = LoggerFactory.getLogger(getClass());
     */
    
    let daemon: Bool

    var terminatedEarly = false
    
    var problemFactChangeQueue = BlockingQueue<ProblemChangeAdapter<Solution_, Score_>>()

    var problemFactChangesBeingProcessed = false;

    public init(daemon: Bool) {
        self.daemon = daemon
    }
    
    // ************************************************************************
    // Concurrency
    // ************************************************************************
    
    // WIP: Test whether this exactly reproduces the original functionality
    private let waker = Waker()
    
    private func wait() async {
        await waker.wait()
    }
    
    private func notifyAll() {
        Task { await waker.wakeAll() }
    }

    // ************************************************************************
    // Plumbing worker methods
    // ************************************************************************

    /**
     * This method is thread-safe.
     */
    // WIP: synchronized
    public func resetTerminateEarly() {
        terminatedEarly = false
    }

    /**
     * This method is thread-safe.
     * <p>
     * Concurrency note: unblocks {@link #waitForRestartSolverDecision()}.
     *
     * @return true if successful
     */
    // WIP: synchronized
    public func terminateEarly() async -> Bool {
        let terminationEarlySuccessful = !terminatedEarly
        terminatedEarly = true
        notifyAll()
        return terminationEarlySuccessful
    }

    /**
     * This method is thread-safe.
     */
    // WIP: synchronized
    public func isTerminateEarly() -> Bool {
        return terminatedEarly
    }

    /**
     * If this returns true, then the problemFactChangeQueue is definitely not empty.
     * <p>
     * Concurrency note: Blocks until {@link #problemFactChangeQueue} is not empty or {@link #terminatedEarly} is true.
     *
     * @return true if the solver needs to be restarted
     */
    // WIP: synchronized
    public func waitForRestartSolverDecision() async -> Bool {
        if !daemon {
            return !problemFactChangeQueue.isEmpty && !terminatedEarly
        } else {
            while (problemFactChangeQueue.isEmpty && !terminatedEarly) {
                await wait()
            }
            return !terminatedEarly
        }
    }

    /**
     * Concurrency note: unblocks {@link #waitForRestartSolverDecision()}.
     *
     * @param problemChange never null
     * @return as specified by {@link Collection#add}
     */
    // WIP: synchronized
    public func addProblemChange(
            _ problemChange: @escaping ProblemChangeAdapter<Solution_, Score_>
    ) -> Bool {
        let added = problemFactChangeQueue.add(problemChange)
        notifyAll()
        return added
    }

    /**
     * Concurrency note: unblocks {@link #waitForRestartSolverDecision()}.
     *
     * @param problemChangeList never null
     * @return as specified by {@link Collection#add}
     */
    // WIP: synchronized
    public func addProblemChanges(
            _ problemChangeList: [ProblemChangeAdapter<Solution_, Score_>]
    ) -> Bool {
        let added = problemFactChangeQueue.addAll(problemChangeList)
        notifyAll()
        return added
    }
    
    // WIP: synchronized
    public func startProblemFactChangesProcessing(
    ) -> BlockingQueue<ProblemChangeAdapter<Solution_, Score_>> {
        problemFactChangesBeingProcessed = true
        return problemFactChangeQueue
    }
    
    // WIP: synchronized
    public func endProblemFactChangesProcessing() {
        problemFactChangesBeingProcessed = false
    }
    
    // WIP: synchronized
    public func isEveryProblemFactChangeProcessed() -> Bool {
        return problemFactChangeQueue.isEmpty && !problemFactChangesBeingProcessed
    }

    // ************************************************************************
    // Termination worker methods
    // ************************************************************************

    // WIP: synchronized
    public func isSolverTerminated(_ solverScope: SolverScope<Solution_, Score_>) -> Bool {
        // Destroying a thread pool with solver threads will only cause it to interrupt those solver threads,
        // it won't call Solver.terminateEarly()
        // WIP: Check whether this is sufficient (uses isInterrupted in original)
        if (Thread.current.isCancelled // Does not clear the interrupted flag
                // Avoid duplicate log message because this method is called twice:
                // - in the phase step loop (every phase termination bridges to the solver termination)
                // - in the solver's phase loop
                && !terminatedEarly) {
            /* WIP: Logger
            logger.info("The solver thread got interrupted, so this solver is terminating early.");
             */
            terminatedEarly = true
        }
        return terminatedEarly || !problemFactChangeQueue.isEmpty
    }

    public func isPhaseTerminated(_ phaseScope: AbstractPhaseScope<Solution_, Score_>) -> Bool {
        return unsupportedOperation(
            String(describing: BasicPlumbingTermination.self)
                + " configured only as solver termination."
                + " It is always bridged to phase termination."
        )
    }

    public func calculateSolverTimeGradient(_ solverScope: SolverScope<Solution_, Score_>) -> Double {
        return -1.0; // Not supported
    }

    public func calculatePhaseTimeGradient(_ phaseScope: AbstractPhaseScope<Solution_, Score_>) -> Double {
        return unsupportedOperation(
            String(describing: BasicPlumbingTermination.self)
                + " configured only as solver termination."
                + " It is always bridged to phase termination."
        )
    }

    // ************************************************************************
    // Other methods
    // ************************************************************************

    public func createChildThreadTermination(
            solverScope: SolverScope<Solution_, Score_>,
            childThreadType: ChildThreadType
    ) -> any Termination<Solution_, Score_> {
        return self
    }

    public func toString() -> String {
        return "BasicPlumbing()"
    }

}
