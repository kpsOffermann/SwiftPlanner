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

protocol PlanningIdAnnotation {}

/**
 * Specifies that a bean property (or a field) is the id to match
 * when {@link ScoreDirector#lookUpWorkingObject(Object) locating}
 * an externalObject (often from another {@link Thread} or JVM).
 * Used during {@link Move} rebasing and in a {@link ProblemChange}.
 * <p>
 * It is specified on a getter of a java bean property (or directly on a field) of a {@link PlanningEntity} class,
 * {@link ValueRangeProvider planning value} class or any {@link ProblemFactCollectionProperty problem fact} class.
 * <p>
 * The return type can be any {@link Comparable} type which overrides {@link Object#equals(Object)} and
 * {@link Object#hashCode()}, and is usually {@link Long} or {@link String}.
 * It must never return a null instance.
 */
// WIP: @Target({ METHOD, FIELD })
// WIP: @Retention(RUNTIME)
@propertyWrapper final class PlanningId<Value> : PlanningIdAnnotation, PropertyAnnotation {
        
    var wrappedValue: Value
    
    init(wrappedValue: Value) {
        self.wrappedValue = wrappedValue
    }
    
}
