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

// WIP: Update documentation source (as soon as all relevant types are ported)

/**
 * A ProblemChange represents a change in one or more {@link PlanningEntity planning entities} or problem facts
 * of a {@link PlanningSolution}.
 * <p>
 * The {@link Solver} checks the presence of waiting problem changes after every
 * {@link org.optaplanner.core.impl.heuristic.move.Move} evaluation. If there are waiting problem changes,
 * the {@link Solver}:
 * <ol>
 * <li>clones the last {@link PlanningSolution best solution} and sets the clone
 * as the new {@link PlanningSolution working solution}</li>
 * <li>applies every problem change keeping the order in which problem changes have been submitted;
 * after every problem change, {@link org.optaplanner.core.api.domain.variable.VariableListener variable listeners}
 * are triggered
 * <li>calculates the score and makes the {@link PlanningSolution updated working solution}
 * the new {@link PlanningSolution best solution}; note that this {@link PlanningSolution solution} is not published
 * via the {@link org.optaplanner.core.api.solver.event.BestSolutionChangedEvent}, as it hasn't been initialized yet</li>
 * <li>restarts solving to fill potential uninitialized {@link PlanningEntity planning entities}</li>
 * </ol>
 * <p>
 * Note that the {@link Solver} clones a {@link PlanningSolution} at will.
 * Any change must be done on the problem facts and planning entities referenced by the {@link PlanningSolution}.
 * <p>
 * An example implementation, based on the Cloud balancing problem, looks as follows:
 *
 * <pre>
 * {@code
 * public class DeleteComputerProblemChange implements ProblemChange<CloudBalance> {
 *
 *     private final CloudComputer computer;
 *
 *     public DeleteComputerProblemChange(CloudComputer computer) {
 *         this.computer = computer;
 *     }
 *
 *     {@literal @Override}
 *     public void doChange(CloudBalance cloudBalance, ProblemChangeDirector problemChangeDirector) {
 *         CloudComputer workingComputer = problemChangeDirector.lookUpWorkingObjectOrFail(computer);
 *         // First remove the problem fact from all planning entities that use it
 *         for (CloudProcess process : cloudBalance.getProcessList()) {
 *             if (process.getComputer() == workingComputer) {
 *                 problemChangeDirector.changeVariable(process, "computer",
 *                         workingProcess -> workingProcess.setComputer(null));
 *             }
 *         }
 *         // A SolutionCloner does not clone problem fact lists (such as computerList), only entity lists.
 *         // Shallow clone the computerList so only the working solution is affected.
 *         ArrayList<CloudComputer> computerList = new ArrayList<>(cloudBalance.getComputerList());
 *         cloudBalance.setComputerList(computerList);
 *         // Remove the problem fact itself
 *         problemChangeDirector.removeProblemFact(workingComputer, computerList::remove);
 *     }
 * }
 * }
 * </pre>
 *
 * @param <Solution_> the solution type, the class with the {@link PlanningSolution} annotation
 */
public protocol ProblemChange<Solution_> {
    
    associatedtype Solution_

    /**
     * Do the change on the {@link PlanningSolution}. Every modification to the {@link PlanningSolution} must
     * be done via the {@link ProblemChangeDirector}, otherwise the {@link Score} calculation will be corrupted.
     *
     * @param workingSolution never null; the {@link PlanningSolution working solution} which contains the problem facts
     *        (and {@link PlanningEntity planning entities}) to change
     * @param problemChangeDirector never null; {@link ProblemChangeDirector} to perform the change through
     */
    func doChange(workingSolution: Solution_, problemChangeDirector: ProblemChangeDirector)
    
}

public extension ProblemChange {
    
    // The equivalent in OptaPlanner is the static method ProblemChangeAdapter.create(problemChange:)
    func adapter<Score_ : Score>() -> ProblemChangeAdapter<Solution_, Score_> {
        return { solverScope in
            self.doChange(
                workingSolution: solverScope.getWorkingSolution(),
                problemChangeDirector: solverScope.getProblemChangeDirector()
            )
            solverScope.getScoreDirector().triggerVariableListeners()
        }
    }
    
}

public class DefaultProblemChange<Solution_> : ProblemChange {
    
    private let doChangeClosure: (Solution_, ProblemChangeDirector) -> Void
    
    init(doChange: @escaping (Solution_, ProblemChangeDirector) -> Void) {
        self.doChangeClosure = doChange
    }
    
    public func doChange(workingSolution: Solution_, problemChangeDirector: ProblemChangeDirector) {
        doChangeClosure(workingSolution, problemChangeDirector)
    }
    
}
