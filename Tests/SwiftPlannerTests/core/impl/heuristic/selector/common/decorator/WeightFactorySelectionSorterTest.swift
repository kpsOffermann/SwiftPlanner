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

class WeightFactorySelectionSorterTest : XCTestCase {

    func test_sortAscending() {
        let weightFactory = WeightFactorySelectionSorterTest.weightFactory
        let selectionSorter = WeightFactorySelectionSorter(weightFactory, order: .ASCENDING)
        let scoreDirector = ScoreDirector_Mock<TestdataSolution>()
        scoreDirector.mock_getWorkingSolution = {
            return TestdataSolution()
        }
        var selectionList = [
            TestdataEntity(code: "C"),
            TestdataEntity(code: "A"),
            TestdataEntity(code: "D"),
            TestdataEntity(code: "B")
        ]
        selectionSorter.sort(scoreDirector: scoreDirector, selectionList: &selectionList)
        PlannerAssert.assertAllCodesOfCollection(selectionList, codes: "A", "B", "C", "D")
    }

    func test_sortDescending() {
        let weightFactory = WeightFactorySelectionSorterTest.weightFactory
        let selectionSorter = WeightFactorySelectionSorter(weightFactory, order: .DESCENDING)
        let scoreDirector = ScoreDirector_Mock<TestdataSolution>()
        scoreDirector.mock_getWorkingSolution = {
            return TestdataSolution()
        }
        var selectionList = [
            TestdataEntity(code: "C"),
            TestdataEntity(code: "A"),
            TestdataEntity(code: "D"),
            TestdataEntity(code: "B")
        ]
        selectionSorter.sort(scoreDirector: scoreDirector, selectionList: &selectionList)
        PlannerAssert.assertAllCodesOfCollection(selectionList, codes: "D", "C", "B", "A")
    }
    
    private static let weightFactory: any SelectionSorterWeightFactory<
            TestdataSolution,
            TestdataEntity
    > = {
        class TestWeightFactory : SelectionSorterWeightFactory {
            
            func createSorterWeight(solution: TestdataSolution, selection: TestdataEntity) -> Int {
                return Int(selection.code[0]?.asciiValue ?? illegalState("selection is empty!"))
            }
            
        }
        return TestWeightFactory()
    }()

}
