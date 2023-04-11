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

protocol PlanningVariableAnnotation {}

/**
 * Specifies that a bean property (or a field) can be changed and should be optimized by the optimization algorithms.
 * <p>
 * It is specified on a getter of a java bean property (or directly on a field) of a {@link PlanningEntity} class.
 */
// WIP: @Target({ METHOD, FIELD })
// WIP: @Retention(RUNTIME)
@propertyWrapper final class PlanningVariable<Value> : PlanningVariableAnnotation {
    
    var wrappedValue: Value

    /**
     * Any {@link ValueRangeProvider} annotation on a {@link PlanningSolution} or {@link PlanningEntity}
     * will automatically be registered with its {@link ValueRangeProvider#id()}.
     * <p>
     * If no refs are provided, all {@link ValueRangeProvider}s without an id will be registered,
     * provided their return types match the type of this variable.
     *
     * @return 0 or more registered {@link ValueRangeProvider#id()}
     */
    var valueRangeProviderRefs: [String]

    /**
     * A nullable planning variable will automatically add the planning value null
     * to the {@link ValueRangeProvider}'s range.
     * <p>
     * Nullable true is not compatible with {@link PlanningVariableGraphType#CHAINED} true.
     * Nullable true is not compatible with a primitive property type.
     *
     * @return true if null is a valid value for this planning variable
     */
    // WIP: Check whether this should be automatically determined from Value type
    var nullable: Bool

    /**
     * In some use cases, such as Vehicle Routing, planning entities form a specific graph type,
     * as specified by {@link PlanningVariableGraphType}.
     *
     * @return never null, defaults to {@link PlanningVariableGraphType#NONE}
     */
    var graphType: PlanningVariableGraphType

    /**
     * Allows a collection of planning values for this variable to be sorted by strength.
     * A strengthWeight estimates how strong a planning value is.
     * Some algorithms benefit from planning on weaker planning values first or from focusing on them.
     * <p>
     * The {@link Comparator} should sort in ascending strength.
     * For example: sorting 3 computers on strength based on their RAM capacity:
     * Computer B (1GB RAM), Computer A (2GB RAM), Computer C (7GB RAM),
     * <p>
     * Do not use together with {@link #strengthWeightFactoryClass()}.
     *
     * @return {@link NullStrengthComparator} when it is null (workaround for annotation limitation)
     * @see #strengthWeightFactoryClass()
     */
    // WIP: Check whether a class is needed
    var strengthComparatorClass: SPComparator<Value>.Type? // nil = NullStrengthComparator.self

    /**
     * The {@link SelectionSorterWeightFactory} alternative for {@link #strengthComparatorClass()}.
     * <p>
     * Do not use together with {@link #strengthComparatorClass()}.
     *
     * @return {@link NullStrengthWeightFactory} when it is null (workaround for annotation limitation)
     * @see #strengthComparatorClass()
     */
    var strengthWeightFactoryClass: (any SelectionSorterWeightFactory.Type)? // nil = NullStrengthWeightFactory.self
    
    init(
            wrappedValue: Value,
            valueRangeProviderRefs: String...,
            nullable: Bool = false,
            graphType: PlanningVariableGraphType = .NONE,
            strengthComparatorClass: SPComparator<Value>.Type? = nil,
            strengthWeightFactoryClass: (any SelectionSorterWeightFactory.Type)? = nil
    ) {
        self.wrappedValue = wrappedValue
        self.valueRangeProviderRefs = valueRangeProviderRefs
        self.nullable = nullable
        self.graphType = graphType
        self.strengthComparatorClass = strengthComparatorClass
        self.strengthWeightFactoryClass = strengthWeightFactoryClass
    }

}
