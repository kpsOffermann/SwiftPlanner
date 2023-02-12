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
 * The ScoreDirector holds the {@link PlanningSolution working solution}
 * and calculates the {@link Score} for it.
 *
 * @param <Solution_> the solution type, the class with the {@link PlanningSolution} annotation
 */
public protocol ScoreDirector<Solution_> {

    associatedtype Solution_
    
    /**
     * The {@link PlanningSolution} that is used to calculate the {@link Score}.
     * <p>
     * Because a {@link Score} is best calculated incrementally (by deltas),
     * the {@link ScoreDirector} needs to be notified when its {@link PlanningSolution working solution} changes.
     *
     * @return never null
     */
    func getWorkingSolution() -> Solution_

    func beforeEntityAdded(_ entity: Any)

    func afterEntityAdded(_ entity: Any)

    func beforeVariableChanged(entity: Any, variableName: String)

    func afterVariableChanged(entity: Any, variableName: String)

    func beforeListVariableElementAssigned(entity: Any, variableName: String, element: Any)

    func afterListVariableElementAssigned(entity: Any, variableName: String, element: Any)

    func beforeListVariableElementUnassigned(entity: Any, variableName: String, element: Any)

    func afterListVariableElementUnassigned(entity: Any, variableName: String, element: Any)

    func beforeListVariableChanged(entity: Any, variableName: String, fromIndex: Int, toIndex: Int)

    func afterListVariableChanged(entity: Any, variableName: String, fromIndex: Int, toIndex: Int)

    func triggerVariableListeners()

    func beforeEntityRemoved(_ entity: Any)

    func afterEntityRemoved(_ entity: Any)

    // TODO extract this set of methods into a separate interface, only used by ProblemFactChange

    func beforeProblemFactAdded(_ problemFact: Any)

    func afterProblemFactAdded(_ problemFact: Any)

    func beforeProblemPropertyChanged(_ problemFactOrEntity: Any)

    func afterProblemPropertyChanged(_ problemFactOrEntity: Any)

    func beforeProblemFactRemoved(_ problemFact: Any)

    func afterProblemFactRemoved(_ problemFact: Any)

    /**
     * Translates an entity or fact instance (often from another {@link Thread} or JVM)
     * to this {@link ScoreDirector}'s internal working instance.
     * Useful for move rebasing and in a {@link ProblemChange}.
     * <p>
     * Matching is determined by the {@link LookUpStrategyType} on {@link PlanningSolution}.
     * Matching uses a {@link PlanningId} by default.
     *
     * @param externalObject sometimes null
     * @return null if externalObject is null
     * @throws IllegalArgumentException if there is no workingObject for externalObject, if it cannot be looked up
     *         or if the externalObject's class is not supported
     * @throws IllegalStateException if it cannot be looked up
     * @param <E> the object type
     */
    func lookUpWorkingObject<E>(_ externalObject: E) -> E

    /**
     * As defined by {@link #lookUpWorkingObject(Object)},
     * but doesn't fail fast if no workingObject was ever added for the externalObject.
     * It's recommended to use {@link #lookUpWorkingObject(Object)} instead,
     * especially in move rebasing code.
     *
     * @param externalObject sometimes null
     * @return null if externalObject is null or if there is no workingObject for externalObject
     * @throws IllegalArgumentException if it cannot be looked up or if the externalObject's class is not supported
     * @throws IllegalStateException if it cannot be looked up
     * @param <E> the object type
     */
    func lookUpWorkingObjectOrReturnNull<E>(_ externalObject: E) -> E?

}
