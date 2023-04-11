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

public protocol PlanningEntityAnnotation {}

/**
 * Specifies that the class is a planning entity.
 * Each planning entity must have at least 1 {@link PlanningVariable} property.
 * <p>
 * The class should have a public no-arg constructor, so it can be cloned
 * (unless the {@link PlanningSolution#solutionCloner()} is specified).
 */
// WIP: @Target({ TYPE })
// WIP: @Retention(RUNTIME)
public protocol PlanningEntity : PlanningEntityAnnotation {

    /**
     * A pinned planning entity is never changed during planning,
     * this is useful in repeated planning use cases (such as continuous planning and real-time planning).
     * <p>
     * This applies to all the planning variables of this planning entity.
     * To pin individual variables, see https://issues.redhat.com/browse/PLANNER-124
     * <p>
     * The method {@link PinningFilter#accept(Object, Object)} returns false if the selection entity is pinned
     * and it returns true if the selection entity is movable
     *
     * @return {@link NullPinningFilter} when it is null (workaround for annotation limitation)
     */
    static func pinningFilter() -> (any PinningFilter.Type)? // nil = NullPinningFilter.self

    /**
     * Allows a collection of planning entities to be sorted by difficulty.
     * A difficultyWeight estimates how hard is to plan a certain PlanningEntity.
     * Some algorithms benefit from planning on more difficult planning entities first/last or from focusing on them.
     * <p>
     * The {@link Comparator} should sort in ascending difficulty
     * (even though many optimization algorithms will reverse it).
     * For example: sorting 3 processes on difficultly based on their RAM usage requirement:
     * Process B (1GB RAM), Process A (2GB RAM), Process C (7GB RAM),
     * <p>
     * Do not use together with {@link #difficultyWeightFactoryClass()}.
     *
     * @return {@link NullDifficultyComparator} when it is null (workaround for annotation limitation)
     * @see #difficultyWeightFactoryClass()
     */
    static func difficultyComparatorClass() -> SPComparator<Self>? // nil = NullDifficultyComparator.self

    /**
     * The {@link SelectionSorterWeightFactory} alternative for {@link #difficultyComparatorClass()}.
     * <p>
     * Do not use together with {@link #difficultyComparatorClass()}.
     *
     * @return {@link NullDifficultyWeightFactory} when it is null (workaround for annotation limitation)
     * @see #difficultyComparatorClass()
     */
    static func difficultyWeightFactoryClass() -> (any SelectionSorterWeightFactory.Type)? // nil = NullDifficultyWeightFactory.self

}

// Default values
extension PlanningEntity {
    
    static func pinningFilter() -> (any PinningFilter.Type)? {
        return nil
    }
    
    static func difficultyComparatorClass() -> SPComparator<Self>? {
        return nil
    }
    
    static func difficultyWeightFactoryClass() -> (any SelectionSorterWeightFactory.Type)? {
        return nil
    }
    
}
