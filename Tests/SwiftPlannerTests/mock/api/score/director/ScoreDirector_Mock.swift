//
/*
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
 */

@testable import SwiftPlanner

/**
 A mockup for a score director.
 
 Each method that is called during the test has to be initialized beforehand/overridden.
 A call to a not-initialized/notoverridden method will result in an illegal state error.
 */
class ScoreDirector_Mock<Solution_> : ScoreDirector {
    
    var mock_getWorkingSolution: (() -> TestdataSolution)?
    
    func getWorkingSolution() -> TestdataSolution {
        (mock_getWorkingSolution ?? illegalState("Not mocked method of ScoreDirector_Mock called!"))()
    }
    
    func beforeEntityAdded(_ entity: Any) {
        illegalState("Not mocked method of ScoreDirector_Mock called!")
    }
    
    func afterEntityAdded(_ entity: Any) {
        illegalState("Not mocked method of ScoreDirector_Mock called!")
    }
    
    func beforeVariableChanged(entity: Any, variableName: String) {
        illegalState("Not mocked method of ScoreDirector_Mock called!")
    }
    
    func afterVariableChanged(entity: Any, variableName: String) {
        illegalState("Not mocked method of ScoreDirector_Mock called!")
    }
    
    func beforeListVariableElementAssigned(entity: Any, variableName: String, element: Any) {
        illegalState("Not mocked method of ScoreDirector_Mock called!")
    }
    
    func afterListVariableElementAssigned(entity: Any, variableName: String, element: Any) {
        illegalState("Not mocked method of ScoreDirector_Mock called!")
    }
    
    func beforeListVariableElementUnassigned(entity: Any, variableName: String, element: Any) {
        illegalState("Not mocked method of ScoreDirector_Mock called!")
    }
    
    func afterListVariableElementUnassigned(entity: Any, variableName: String, element: Any) {
        illegalState("Not mocked method of ScoreDirector_Mock called!")
    }
    
    func beforeListVariableChanged(entity: Any, variableName: String, fromIndex: Int, toIndex: Int) {
        illegalState("Not mocked method of ScoreDirector_Mock called!")
    }
    
    func afterListVariableChanged(entity: Any, variableName: String, fromIndex: Int, toIndex: Int) {
        illegalState("Not mocked method of ScoreDirector_Mock called!")
    }
    
    func triggerVariableListeners() {
        illegalState("Not mocked method of ScoreDirector_Mock called!")
    }
    
    func beforeEntityRemoved(_ entity: Any) {
        illegalState("Not mocked method of ScoreDirector_Mock called!")
    }
    
    func afterEntityRemoved(_ entity: Any) {
        illegalState("Not mocked method of ScoreDirector_Mock called!")
    }
    
    func beforeProblemFactAdded(_ problemFact: Any) {
        illegalState("Not mocked method of ScoreDirector_Mock called!")
    }
    
    func afterProblemFactAdded(_ problemFact: Any) {
        illegalState("Not mocked method of ScoreDirector_Mock called!")
    }
    
    func beforeProblemPropertyChanged(_ problemFactOrEntity: Any) {
        illegalState("Not mocked method of ScoreDirector_Mock called!")
    }
    
    func afterProblemPropertyChanged(_ problemFactOrEntity: Any) {
        illegalState("Not mocked method of ScoreDirector_Mock called!")
    }
    
    func beforeProblemFactRemoved(_ problemFact: Any) {
        illegalState("Not mocked method of ScoreDirector_Mock called!")
    }
    
    func afterProblemFactRemoved(_ problemFact: Any) {
        illegalState("Not mocked method of ScoreDirector_Mock called!")
    }
    
    func lookUpWorkingObject<E>(_ externalObject: E) -> E {
        illegalState("Not mocked method of ScoreDirector_Mock called!")
    }
    
    func lookUpWorkingObjectOrReturnNull<E>(_ externalObject: E) -> E? {
        illegalState("Not mocked method of ScoreDirector_Mock called!")
    }
    
}
