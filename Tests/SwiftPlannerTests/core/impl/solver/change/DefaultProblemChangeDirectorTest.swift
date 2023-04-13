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

import XCTest
@testable import SwiftPlanner

class DefaultProblemChangeDirectorTest : XCTestCase {

    func test_complexProblemChange_correctlyNotifiesScoreDirector() {
        let entityGroupOne = TestdataLavishEntityGroup(code: "entityGroupOne")
        let valueGroupOne = TestdataLavishValueGroup(code: "valueGroupOne")
        let addedEntity = TestdataLavishEntity(
            code: "newly added entity",
            entityGroup: entityGroupOne
        )
        let removedEntity = TestdataLavishEntity(
            code: "entity to remove",
            entityGroup: entityGroupOne
        )
        let addedFact = TestdataLavishValue(
            code: "newly added fact",
            valueGroup: valueGroupOne
        )
        let removedFact = TestdataLavishValue(
            code: "fact to remove",
            valueGroup: valueGroupOne
        )
        let changedEntity = TestdataLavishEntity(
            code: "changed entity",
            entityGroup: entityGroupOne
        )
        let changedEntityValue = TestdataLavishValue(
            code: "changed entity value",
            valueGroup: valueGroupOne
        )

        let scoreDirectorMock = InnerScoreDirector_Mock<TestdataLavishSolution, SimpleScore>()
        scoreDirectorMock.mock_lookUpWorkingObject = { expectedObject in
            switch (removedEntity) {
                case removedEntity, changedEntity, removedFact: return expectedObject
                default: return illegalState(
                    "mock of lookUpWorkingObject not configured for input \(expectedObject)"
                )
            }
        }
        let defaultProblemChangeDirector = DefaultProblemChangeDirector(scoreDirector: scoreDirectorMock)
        let problemChange = DefaultProblemChange<TestdataLavishSolution>(
            doChange: { workingSolution, problemChangeDirector in
                // Add an entity.
                problemChangeDirector.addEntity(
                    addedEntity,
                    via: { workingSolution.entityList?.append($0) }
                )
                // Remove an entity.
                problemChangeDirector.removeEntity(
                    removedEntity,
                    via: { _ = workingSolution.entityList?.removeFirstEqual($0) }
                )
                // Change a planning variable.
                problemChangeDirector.changeVariable(
                    entity: changedEntity,
                    variableName: TestdataLavishEntity.VALUE_FIELD,
                    entityConsumer: { $0.setValue(changedEntityValue) }
                )
                // Change a property
                problemChangeDirector.changeProblemProperty(
                    changedEntity,
                    via: { $0.entityGroup = entityGroupOne }
                )
                // Add a problem fact.
                problemChangeDirector.addProblemFact(
                    addedFact,
                    via: { workingSolution.valueList?.append($0) }
                )
                // Remove a problem fact.
                problemChangeDirector.removeProblemFact(
                    removedFact,
                    via: { _ = workingSolution.valueList?.removeFirstEqual($0) }
                )
            }
        )

        let testdataSolution = TestdataLavishSolution.generateSolution()
        testdataSolution.entityList?.append(removedEntity)
        testdataSolution.entityList?.append(changedEntity)
        testdataSolution.valueList?.append(removedFact)
        testdataSolution.valueList?.append(changedEntityValue)

        problemChange.doChange(
            workingSolution: testdataSolution,
            problemChangeDirector: defaultProblemChangeDirector
        )
        
        XCTAssertCallsTo(
            scoreDirectorMock.callsTo_beforeEntityAdded,
            parameter: addedEntity,
            count: 1
        )
        XCTAssertCallsTo(
            scoreDirectorMock.callsTo_afterEntityAdded,
            parameter: addedEntity,
            count: 1
        )
        
        XCTAssertCallsTo(
            scoreDirectorMock.callsTo_beforeEntityRemoved,
            parameter: removedEntity,
            count: 1
        )
        XCTAssertCallsTo(
            scoreDirectorMock.callsTo_afterEntityRemoved,
            parameter: removedEntity,
            count: 1
        )

        XCTAssertCallsTo(
            scoreDirectorMock.callsTo_beforeVariableChanged,
            parameter: (changedEntity, TestdataEntity.VALUE_FIELD),
            count: 1
        )
        XCTAssertCallsTo(
            scoreDirectorMock.callsTo_afterVariableChanged,
            parameter: (changedEntity, TestdataEntity.VALUE_FIELD),
            count: 1
        )
        
        XCTAssertCallsTo(
            scoreDirectorMock.callsTo_beforeProblemPropertyChanged,
            parameter: changedEntity,
            count: 1
        )
        XCTAssertCallsTo(
            scoreDirectorMock.callsTo_afterProblemPropertyChanged,
            parameter: changedEntity,
            count: 1
        )
        
        XCTAssertCallsTo(
            scoreDirectorMock.callsTo_beforeProblemFactAdded,
            parameter: addedFact,
            count: 1
        )
        XCTAssertCallsTo(
            scoreDirectorMock.callsTo_afterProblemFactAdded,
            parameter: addedFact,
            count: 1
        )
        
        XCTAssertCallsTo(
            scoreDirectorMock.callsTo_beforeProblemFactRemoved,
            parameter: removedFact,
            count: 1
        )
        XCTAssertCallsTo(
            scoreDirectorMock.callsTo_afterProblemFactRemoved,
            parameter: removedFact,
            count: 1
        )
    }

}
