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

// WIP: annotations

@testable import SwiftPlanner

// WIP: @PlanningSolution
public class TestdataSolution : TestdataObject {

    public static func buildSolutionDescriptor() -> SolutionDescriptor<TestdataSolution> {
        return SolutionDescriptor.buildSolutionDescriptor(
            TestdataSolution.self,
            entityClasses: TestdataEntity.self
        )
    }

    public static func generateSolution() -> TestdataSolution {
        return generateSolution(valueListSize: 5, entityListSize: 7)
    }

    public static func generateSolution(valueListSize: Int, entityListSize: Int) -> TestdataSolution {
        let solution = TestdataSolution(code: "Generated Solution 0")
        let valueList = (0..<valueListSize).map({ TestdataValue(code: "Generated Value " + $0) })
        solution.valueList = valueList
        let entityList = (0..<entityListSize).map({
            TestdataEntity(code: "Generated Entity " + $0, value: valueList[mod: $0])
        })
        solution.entityList = entityList
        return solution
    }

    /* WIP: annotations
    @ValueRangeProvider(id = "valueRange")
    @ProblemFactCollectionProperty
     */
    private var valueList: [TestdataValue]?
    /* WIP: annotations
    @PlanningEntityCollectionProperty
     */
    public var entityList: [TestdataEntity]?

    /* WIP: annotations
     @PlanningScore
     */
    public var score: SimpleScore?

    public override init() {
        super.init()
    }

    public override init(code: String) {
        super.init(code: code)
    }

    // ************************************************************************
    // Complex methods
    // ************************************************************************

}
