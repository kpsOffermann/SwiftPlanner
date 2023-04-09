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

/* WIP: Check mirror annotation lookup for multiple (nested?) annotations,
        e. g. TestdataLavishSolution.valueList
 */

protocol ValueRangeProviderAnnotation {
    
    var id: String { get }
    
}

/**
 * Provides the planning values that can be used for a {@link PlanningVariable}.
 * <p>
 * This is specified on a getter of a java bean property (or directly on a field)
 * which returns a {@link Collection} or {@link ValueRange}.
 * A {@link Collection} is implicitly converted to a {@link ValueRange}.
 */
// WIP: @Target({ METHOD, FIELD })
// WIP: @Retention(RUNTIME)

@propertyWrapper final class ValueRangeProvider<Value> : ValueRangeProviderAnnotation {
    
    var wrappedValue: Value

    /**
     * Used by {@link PlanningVariable#valueRangeProviderRefs()}
     * to map a {@link PlanningVariable} to a {@link ValueRangeProvider}.
     * If not provided, an attempt will be made to find a matching {@link PlanningVariable} without a ref.
     *
     * @return if provided, must be unique across a {@link SolverFactory}
     */
    var id: String
    
    init(wrappedValue: Value, id: String = "") {
        self.wrappedValue = wrappedValue
        self.id = id
    }

}
