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

// WIP: currently contains only methods that are used somewhere else
// WIP: constructor body
public class EntityDescriptor<Solution_> {
    
    // Caches the inherited, declared and descending movable filters (including @PlanningPin filters) as a composite filter
    private var effectiveMovableEntitySelectionFilter: (any SelectionFilter<Solution_, Any>)?
    
    public init(_ solutionDescriptor: SolutionDescriptor<Solution_>?, _ entityClass: Any.Type) {
        // WIP
    }
    
    public func isMovable(scoreDirector: any ScoreDirector<Solution_>, entity: Any) -> Bool {
        return effectiveMovableEntitySelectionFilter?.accept(
                scoreDirector: scoreDirector,
                selection: entity
            ) ?? true
    }
    
}
