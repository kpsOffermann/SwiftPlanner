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

/* WIP: requires annotations for
        value
 */
// WIP: BigInteger, BigDecimal

@testable import SwiftPlanner

// WIP: @PlanningEntity
public class TestdataLavishEntity : TestdataObject {
    
    public static let VALUE_FIELD = "value"

    public static func buildEntityDescriptor() -> EntityDescriptor<TestdataLavishSolution> {
        return TestdataLavishSolution.buildSolutionDescriptor()
                .findEntityDescriptorOrFail(TestdataLavishEntity.self)
    }
    
    public static func buildVariableDescriptorForValue(
    ) -> GenuineVariableDescriptor<TestdataLavishSolution>? {
        return buildEntityDescriptor().getGenuineVariableDescriptor("value")
    }

    public var entityGroup: TestdataLavishEntityGroup
    @PlanningVariable(valueRangeProviderRefs: "valueRange")
    public private(set) var value: TestdataLavishValue? = nil

    public var stringProperty = ""
    public var integerProperty = 1
    public var longProperty: Int64 = 1
    /* WIP: BigInteger, BigDecimal
    private BigInteger bigIntegerProperty = BigInteger.ONE;
    private BigDecimal bigDecimalProperty = BigDecimal.ONE;
     */

    /* WIP: Check whether parameterless constructor is necessary
    public override init() {
        super.init()
    }
     */

    public init(code: String, entityGroup: TestdataLavishEntityGroup, value: TestdataLavishValue? = nil) {
        self.entityGroup = entityGroup
        self.value = value
        super.init(code: code)
    }

    // ************************************************************************
    // Getter/setters
    // ************************************************************************

    public func setValue(_ value: TestdataLavishValue) {
        self.value = value
    }
    
    /* WIP: BigInteger, BigDecimal
    public BigInteger getBigIntegerProperty() {
        return bigIntegerProperty;
    }

    public void setBigIntegerProperty(BigInteger bigIntegerProperty) {
        this.bigIntegerProperty = bigIntegerProperty;
    }

    public BigDecimal getBigDecimalProperty() {
        return bigDecimalProperty;
    }

    public void setBigDecimalProperty(BigDecimal bigDecimalProperty) {
        this.bigDecimalProperty = bigDecimalProperty;
    }
    */
    
}
