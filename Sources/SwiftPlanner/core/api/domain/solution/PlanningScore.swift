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

protocol PlanningScoreAnnotation {}

/**
 * Specifies that a property (or a field) on a {@link PlanningSolution} class holds the {@link Score} of that solution.
 * <p>
 * This property can be null if the {@link PlanningSolution} is uninitialized.
 * <p>
 * This property is modified by the {@link Solver},
 * every time when the {@link Score} of this {@link PlanningSolution} has been calculated.
 */
// WIP: @Target({ METHOD, FIELD })
// WIP: @Retention(RUNTIME)
@propertyWrapper final class PlanningScore<Value> : PlanningScoreAnnotation, PropertyAnnotation {
    
    var wrappedValue: Value

    /**
     * Required for bendable scores.
     * <p>
     * For example with 3 hard levels, hard level 0 always outweighs hard level 1 which always outweighs hard level 2,
     * which outweighs all the soft levels.
     *
     * @return 0 or higher if the {@link Score} is a {@link IBendableScore}, not used otherwise
     */
    var bendableHardLevelsSize: Int? // nil == NO_LEVEL_SIZE

    /**
     * Required for bendable scores.
     * <p>
     * For example with 3 soft levels, soft level 0 always outweighs soft level 1 which always outweighs soft level 2.
     *
     * @return 0 or higher if the {@link Score} is a {@link IBendableScore}, not used otherwise
     */
    var bendableSoftLevelsSize: Int? // nil == NO_LEVEL_SIZE
    
    init(
            wrappedValue: Value,
            bendableHardLevelsSize: Int? = nil,
            bendableSoftLevelsSize: Int? = nil
    ) {
        self.wrappedValue = wrappedValue
        self.bendableHardLevelsSize = bendableHardLevelsSize
        self.bendableSoftLevelsSize = bendableSoftLevelsSize
    }

}
