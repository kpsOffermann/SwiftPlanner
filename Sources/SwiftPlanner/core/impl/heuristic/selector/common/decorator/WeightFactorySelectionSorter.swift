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

// WIP: Check whether Equatable, Hashable are necessary.

/**
 * Sorts a selection {@link List} based on a {@link SelectionSorterWeightFactory}.
 *
 * @param <Solution_> the solution type, the class with the {@link PlanningSolution} annotation
 * @param <T> the selection type
 */
public final class WeightFactorySelectionSorter<Solution_, T : Hashable> : SelectionSorter {

    private let selectionSorterWeightFactory: any SelectionSorterWeightFactory<Solution_, T>
    private let selectionSorterOrder: SelectionSorterOrder

    public init(
            _ selectionSorterWeightFactory: any SelectionSorterWeightFactory<Solution_, T>,
            order selectionSorterOrder: SelectionSorterOrder
    ) {
        self.selectionSorterWeightFactory = selectionSorterWeightFactory
        self.selectionSorterOrder = selectionSorterOrder
    }

    public func sort(scoreDirector: some ScoreDirector<Solution_>, selectionList: inout [T]) {
        sort(solution: scoreDirector.getWorkingSolution(), selectionList: &selectionList)
    }

    /**
     * @param solution never null, the {@link PlanningSolution} to which the selections belong or apply to
     * @param selectionList never null, a {@link List}
     *        of {@link PlanningEntity}, planningValue, {@link Move} or {@link Selector}
     */
    public func sort(solution: Solution_, selectionList: inout [T]) {
        // WIP: Check effects of elements with same weight.
        let comparator = Comparators.by(
            {
                self.selectionSorterWeightFactory.createSorterWeight(
                    solution: solution,
                    selection: $0
                )
            },
            orElse: {
                fatalError(
                    "This code is unreachable since createSorterWeight returns elements of one "
                        + " SPComparable subtype"
                )
            }
        )
        selectionList.sort(
            selectionSorterOrder == .ASCENDING ? comparator : Comparators.reversed(comparator)
        )
    }
    
}
