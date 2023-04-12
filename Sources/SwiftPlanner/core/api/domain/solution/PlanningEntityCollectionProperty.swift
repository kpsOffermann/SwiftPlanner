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

protocol PlanningEntityCollectionPropertyAnnotation {}

/**
 * Specifies that a property (or a field) on a {@link PlanningSolution} class is a {@link Collection} of planning entities.
 * <p>
 * Every element in the planning entity collection should have the {@link PlanningEntity} annotation.
 * Every element in the planning entity collection will be added to the {@link ScoreDirector}.
 */
// WIP: @Target({ METHOD, FIELD })
// WIP: @Retention(RUNTIME)
@propertyWrapper final class PlanningEntityCollectionProperty<
        Value
> : PlanningEntityCollectionPropertyAnnotation, PropertyAnnotation {
        
    var wrappedValue: Value
    
    init(wrappedValue: Value) {
        self.wrappedValue = wrappedValue
    }
    
}
