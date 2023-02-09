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

// WIP: complete test_getJustificationList

import XCTest
@testable import SwiftPlanner

class DefaultIndictmentTest : XCTestCase {

    func test_getScoreTotal() {
        // WIP: Replace all three with TestdataEntity
        let e1 = TestdataObject(code: "e1")
        let e2 = TestdataObject(code: "e2")
        let e3 = TestdataObject(code: "e3")
        let indictment = DefaultIndictment(indictedObject: e1, zeroScore: SimpleScore.ZERO)
        XCTAssertEqual(indictment.getScore(), SimpleScore.ZERO)

        let match1 = buildConstraintMatch("package1", "constraint1", SimpleScore.of(-1), e1)
        indictment.addConstraintMatch(match1)
        XCTAssertEqual(indictment.getScore(), SimpleScore.of(-1))
        // Different constraintName
        let match2 = buildConstraintMatch("package1", "constraint2", SimpleScore.of(-20), e1)
        indictment.addConstraintMatch(match2)
        XCTAssertEqual(indictment.getScore(), SimpleScore.of(-21))
        indictment.addConstraintMatch(
            buildConstraintMatch("package1", "constraint3", SimpleScore.of(-300), e1, e2)
        )
        XCTAssertEqual(indictment.getScore(), SimpleScore.of(-321))
        // Different justification
        indictment.addConstraintMatch(
            buildConstraintMatch("package1", "constraint3", SimpleScore.of(-4000), e1, e3)
        )
        XCTAssertEqual(indictment.getScore(), SimpleScore.of(-4321))
        // Almost duplicate, but e2 and e1 are in reverse order, so different justification
        indictment.addConstraintMatch(
            buildConstraintMatch("package1", "constraint3", SimpleScore.of(-50000), e2, e1)
        )
        XCTAssertEqual(indictment.getScore(), SimpleScore.of(-54321))

        indictment.removeConstraintMatch(match2)
        XCTAssertEqual(indictment.getScore(), SimpleScore.of(-54301))
        indictment.removeConstraintMatch(match1)
        XCTAssertEqual(indictment.getScore(), SimpleScore.of(-54300))
    }
    
    func test_addAndRemoveMatch() {
        let score = SimpleScore.of(-1)
        let indictments = [TestdataObject(code: "e1")]
        let match: ConstraintMatch<SimpleScore> = ConstraintMatch(
            constraintPackage: "package1",
            constraintName: "constraint2",
            justification: DefaultConstraintJustification.of(impact: score, facts: indictments),
            indictedObjects: indictments,
            score: score
        )
        let indictment = DefaultIndictment(indictedObject: "", zeroScore: SimpleScore.ZERO)
        indictment.addConstraintMatch(match)
        indictment.removeConstraintMatch(match)
        XCTAssertEqual(indictment.getScore(), SimpleScore.ZERO)
    }

    func test_getJustificationList() {
        // WIP: Replace all three with TestdataEntity
        let e1 = TestdataObject(code: "e1")
        let e2 = TestdataObject(code: "e2")
        let e3 = TestdataObject(code: "e3")
        let indictment = DefaultIndictment(indictedObject: e1, zeroScore: SimpleScore.ZERO)
        XCTAssertEqual(indictment.getScore(), SimpleScore.ZERO)

        // Add a constraint match with a default justification
        let match1 = buildConstraintMatch("package1", "constraint1", SimpleScore.of(-1), e1, e2)
        indictment.addConstraintMatch(match1)

        assertJustifications(
            list: indictment.getJustificationList(),
            expectedCount: 1,
            expectedFacts0: [e1, e2]
        )
        
        assertJustifications(
            list: indictment.getJustificationList(
                justificationClass: DefaultConstraintJustification.self
            ),
            expectedCount: 1,
            expectedFacts0: [e1, e2]
        )

        // Add another constraint match with a custom justification
        let match2 = ConstraintMatch(
            constraintPackage: "package1",
            constraintName: "constraint1",
            justification: TestConstraintJustification(facts: e1, e3),
            indictedObjects: [e1, e3],
            score: SimpleScore.of(-1)
        )
        indictment.addConstraintMatch(match2)
        /*
        assertJustifications(
            list: indictment.getJustificationList(),
            expectedCount: 2,
            expectedFacts0: [e1, e2],
            expectedFacts1: [e1, e3]
        )
        
        assertJustifications(
            list: indictment.getJustificationList(
                justificationClass: DefaultConstraintJustification.self
            ),
            expectedCount: 1,
            expectedFacts0: [e1, e2]
        )
        
        assertJustifications(
            list: indictment.getJustificationList(
                justificationClass: TestConstraintJustification.self
            ),
            expectedCount: 1,
            expectedFacts0: [e1, e3]
        )*/
    }

    func test_equalsAndHashCode() {
        PlannerAssert.assertObjectsAreEqual(
            DefaultIndictment(indictedObject: "e1", zeroScore: SimpleScore.ZERO),
            DefaultIndictment(indictedObject: "e1", zeroScore: SimpleScore.ZERO),
            DefaultIndictment(indictedObject: "e1", zeroScore: SimpleScore.of(-7))
        )
        PlannerAssert.assertObjectsAreNotEqual(
            DefaultIndictment(indictedObject: "a", zeroScore: SimpleScore.ZERO),
            DefaultIndictment(indictedObject: "aa", zeroScore: SimpleScore.ZERO),
            DefaultIndictment(indictedObject: "b", zeroScore: SimpleScore.ZERO),
            DefaultIndictment(indictedObject: "c", zeroScore: SimpleScore.ZERO)
        )
    }
    
    private final class TestConstraintJustification : ConstraintJustification {
        
        var description: String {
            String(describing: facts)
        }

        private let facts: [Any]

        public init(facts: Any...) {
            self.facts = facts
        }

        public func getFacts() -> [Any] {
            return facts
        }
    }
    
    private func buildConstraintMatch<Score_ : Score>(
            _ constraintPackage: String,
            _ constraintName: String,
            _ score: Score_,
            _ indictments: CustomStringConvertible...
    ) -> ConstraintMatch<Score_> {
        return ConstraintMatch(
            constraintPackage: constraintPackage,
            constraintName: constraintName,
            justification: DefaultConstraintJustification.of(score, facts: indictments),
            indictedObjects: indictments,
            score: score
        )
    }
    
    // use only for DefaultConstraintJustification or TestConstraintJustification
    private func assertJustifications(
            list: [ConstraintJustification],
            expectedCount: Int,
            expectedFacts0: [TestdataObject],
            expectedFacts1: [TestdataObject]? = nil,
            file: StaticString = #file,
            line: UInt = #line
    ) {
        XCTAssertEqual(list.count, expectedCount)
        assertFacts(list, 0, expectedFacts0, file: file, line: line)
        if let facts1 = expectedFacts1 {
            assertFacts(list, 1, facts1, file: file, line: line)
        }
    }
    
    // use only for DefaultConstraintJustification or TestConstraintJustification
    private func assertFacts(
            _ list: [ConstraintJustification],
            _ index: Int,
            _ expectedFacts: [TestdataObject],
            file: StaticString = #file,
            line: UInt = #line
    ) {
        let justification = list[index]
        guard let untypedFacts = (justification as? DefaultConstraintJustification)?.getFacts()
                ?? (justification as? TestConstraintJustification)?.getFacts() else {
            XCTAssertTrue(false,
                "Justification \(justification) (index: \(index)) of indictment has to be of type "
                    + "DefaultConstraintJustification or of type TestConstraintJustification, "
                    + "but is of type " + String(describing: type(of: justification)),
                file: file,
                line: line
            )
            return
        }
        guard let facts = untypedFacts as? [TestdataObject] else {
            XCTAssertTrue(false,
                "Facts \(untypedFacts) has to be of type [TestdataObject], but is of type "
                    + String(describing: type(of: untypedFacts)),
                file: file,
                line: line
            )
            return
        }
        XCTAssertEqualIgnoringOrder(facts, expectedFacts)
    }

}
