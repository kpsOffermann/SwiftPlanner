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

/* WIP: requires @Target, requires @Retention for
    class annotations
*/

public protocol PlanningSolutionAnnotation {}

/**
 * Specifies that the class is a planning solution.
 * A solution represents a problem and a possible solution of that problem.
 * A possible solution does not need to be optimal or even feasible.
 * A solution's planning variables might not be initialized (especially when delivered as a problem).
 * <p>
 * A solution is mutable.
 * For scalability reasons (to facilitate incremental score calculation),
 * the same solution instance (called the working solution per move thread) is continuously modified.
 * It's cloned to recall the best solution.
 * <p>
 * Each planning solution must have exactly 1 {@link PlanningScore} property.
 * <p>
 * Each planning solution must have at least 1 {@link PlanningEntityCollectionProperty}
 * or {@link PlanningEntityProperty} property.
 * <p>
 * Each planning solution is recommended to have 1 {@link ConstraintConfigurationProvider} property too.
 * <p>
 * Each planning solution used with Drools score calculation must have at least 1 {@link ProblemFactCollectionProperty}
 * or {@link ProblemFactProperty} property.
 * <p>
 * The class should have a public no-arg constructor, so it can be cloned
 * (unless the {@link #solutionCloner()} is specified).
 */
// WIP: @Target({ TYPE })
// WIP: @Retention(RUNTIME)
public protocol PlanningSolution : PlanningSolutionAnnotation, ClassAnnotation {

    /**
     * Enable reflection through the members of the class
     * to automatically assume {@link PlanningScore}, {@link PlanningEntityCollectionProperty},
     * {@link PlanningEntityProperty}, {@link ProblemFactCollectionProperty}, {@link ProblemFactProperty}
     * and {@link ConstraintConfigurationProvider} annotations based on the member type.
     *
     * @return never null
     */
    static func autoDiscoverMemberType() -> AutoDiscoverMemberType

    /**
     * Overrides the default {@link SolutionCloner} to implement a custom {@link PlanningSolution} cloning implementation.
     * <p>
     * If this is not specified, then the default reflection-based {@link SolutionCloner} is used,
     * so you don't have to worry about it.
     *
     * @return {@link NullSolutionCloner} when it is null (workaround for annotation limitation)
     */
    static func solutionCloner() -> (any SolutionCloner.Type)? // nil = NullSolutionCloner.self

    /**
     * @return never null
     */
    static func lookUpStrategyType() -> LookUpStrategyType

}

// Default values
extension PlanningSolution {
    
    static func autoDiscoverMemberType() -> AutoDiscoverMemberType {
        return .NONE
    }
    
    static func solutionCloner() -> (any SolutionCloner.Type)? {
        return nil
    }
    
    static func lookUpStrategyType() -> LookUpStrategyType {
        return .PLANNING_ID_OR_NONE
    }
}
