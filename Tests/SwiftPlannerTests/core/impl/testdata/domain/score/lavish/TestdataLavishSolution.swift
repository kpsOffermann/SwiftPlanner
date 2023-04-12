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

@testable import SwiftPlanner

// @PlanningSolution implemented by conformance
public class TestdataLavishSolution : TestdataObject, PlanningSolution {

    public static func buildSolutionDescriptor(
    ) -> SolutionDescriptor<TestdataLavishSolution, SimpleScore> {
        return SolutionDescriptor<TestdataLavishSolution, SimpleScore>.buildSolutionDescriptor(
            TestdataLavishSolution.self,
            entityClasses: TestdataLavishEntity.self
        )
    }
    
    public static func generateSolution() -> TestdataLavishSolution {
        return generateSolution(
            valueGroupListSize: 2,
            valueListSize: 5,
            entityGroupListSize: 3,
            entityListSize: 7
        )
    }

    public static func generateSolution(
            valueListSize: Int,
            entityListSize: Int
    ) -> TestdataLavishSolution {
        return generateSolution(
            valueGroupListSize: 2,
            valueListSize: valueListSize,
            entityGroupListSize: 3,
            entityListSize: entityListSize
        )
    }

    public static func generateSolution(
            valueGroupListSize: Int,
            valueListSize: Int,
            entityGroupListSize: Int,
            entityListSize: Int
    ) -> TestdataLavishSolution {
        let solution = TestdataLavishSolution(code: "Generated Solution 0")
        let valueGroupList = (0..<valueGroupListSize).map({
            TestdataLavishValueGroup(code: "Generated ValueGroup " + $0)
        })
        solution.valueGroupList = valueGroupList
        let valueList = (0..<valueListSize).map({
            TestdataLavishValue(code: "Generated Value " + $0, valueGroup: valueGroupList[mod: $0])
        })
        solution.valueList = valueList
        solution.extraList = []
        let entityGroupList = (0..<entityGroupListSize).map({
            TestdataLavishEntityGroup(code: "Generated EntityGroup " + $0)
        })
        solution.entityGroupList = entityGroupList
        let entityList = (0..<entityListSize).map({
            TestdataLavishEntity(
                code: "Generated Entity " + $0,
                entityGroup: entityGroupList[mod: $0],
                value: valueList[mod: $0]
            )
        })
        solution.entityList = entityList
        return solution
    }

    @ProblemFactCollectionProperty
    public private(set) var valueGroupList: [TestdataLavishValueGroup]?
    // WIP: Check mirror annotation lookup for multiple (nested?) annotations
    @ValueRangeProvider(id: "valueRange")
    @ProblemFactCollectionProperty
    public private(set) var valueList: [TestdataLavishValue]? = nil
    @ProblemFactCollectionProperty
    public private(set) var extraList: [TestdataLavishExtra]?
    @ProblemFactCollectionProperty
    public private(set) var entityGroupList: [TestdataLavishEntityGroup]?
    @PlanningEntityCollectionProperty
    public private(set) var entityList: [TestdataLavishEntity]?

    @PlanningScore
    public private(set) var score: SimpleScore?

    public override init() {
        super.init()
    }

    public override init(code: String) {
        super.init(code: code)
    }

    public func getFirstValueGroup() -> TestdataLavishValueGroup? {
        return valueGroupList?.first
    }

    public func getFirstValue() -> TestdataLavishValue? {
        return valueList?.first
    }

    public func getFirstEntityGroup() -> TestdataLavishEntityGroup? {
        return entityGroupList?.first
    }

    public func getFirstEntity() -> TestdataLavishEntity? {
        return entityList?.first
    }
    
    // ************************************************************************
    // Getter/setters
    // ************************************************************************

    public func setValueGroupList(_ valueGroupList: [TestdataLavishValueGroup]) {
        self.valueGroupList = valueGroupList
    }

    public func setValueList(_ valueList: [TestdataLavishValue]) {
        self.valueList = valueList
    }

    public func setExtraList(_ extraList: [TestdataLavishExtra]) {
        self.extraList = extraList
    }

    public func setEntityGroupList(_ entityGroupList: [TestdataLavishEntityGroup]) {
        self.entityGroupList = entityGroupList
    }

    public func setEntityList(_ entityList: [TestdataLavishEntity]) {
        self.entityList = entityList
    }

    public func setScore(_ score: SimpleScore) {
        self.score = score
    }
    
}
