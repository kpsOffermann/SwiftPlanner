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
class ScoreDirector_Mock<Solution_ : PlanningSolution> : ScoreDirector {
    
    var mock_getWorkingSolution: (() -> Solution_)?
    
    func getWorkingSolution() -> Solution_ {
        (mock_getWorkingSolution ?? illegalState("Not mocked method of ScoreDirector_Mock called!"))()
    }
    
    var callsTo_beforeEntityAdded = [Any]()
    
    func beforeEntityAdded(_ entity: Any) {
        callsTo_beforeEntityAdded.append(entity)
        /* Do nothing */
    }
    
    var callsTo_afterEntityAdded = [Any]()
    
    func afterEntityAdded(_ entity: Any) {
        callsTo_afterEntityAdded.append(entity)
        /* Do nothing */
    }
    
    var callsTo_beforeVariableChanged = [(Any, String)]()
    
    func beforeVariableChanged(entity: Any, variableName: String) {
        callsTo_beforeVariableChanged.append((entity, variableName))
        /* Do nothing */
    }
    
    var callsTo_afterVariableChanged = [(Any, String)]()
    
    func afterVariableChanged(entity: Any, variableName: String) {
        callsTo_afterVariableChanged.append((entity, variableName))
        /* Do nothing */
    }
    
    func beforeListVariableElementAssigned(entity: Any, variableName: String, element: Any) {
        /* Do nothing */
    }
    
    func afterListVariableElementAssigned(entity: Any, variableName: String, element: Any) {
        /* Do nothing */
    }
    
    func beforeListVariableElementUnassigned(entity: Any, variableName: String, element: Any) {
        /* Do nothing */
    }
    
    func afterListVariableElementUnassigned(entity: Any, variableName: String, element: Any) {
        /* Do nothing */
    }
    
    func beforeListVariableChanged(entity: Any, variableName: String, fromIndex: Int, toIndex: Int) {
        /* Do nothing */
    }
    
    func afterListVariableChanged(entity: Any, variableName: String, fromIndex: Int, toIndex: Int) {
        /* Do nothing */
    }
    
    func triggerVariableListeners() {
        /* Do nothing */
    }
    
    var callsTo_beforeEntityRemoved = [Any]()
    
    func beforeEntityRemoved(_ entity: Any) {
        callsTo_beforeEntityRemoved.append(entity)
        /* Do nothing */
    }
    
    var callsTo_afterEntityRemoved = [Any]()
    
    func afterEntityRemoved(_ entity: Any) {
        callsTo_afterEntityRemoved.append(entity)
        /* Do nothing */
    }
    
    var callsTo_beforeProblemFactAdded = [Any]()
    
    func beforeProblemFactAdded(_ problemFact: Any) {
        callsTo_beforeProblemFactAdded.append(problemFact)
        /* Do nothing */
    }
    
    var callsTo_afterProblemFactAdded = [Any]()
    
    func afterProblemFactAdded(_ problemFact: Any) {
        callsTo_afterProblemFactAdded.append(problemFact)
        /* Do nothing */
    }
    
    var callsTo_beforeProblemPropertyChanged = [Any]()
    
    func beforeProblemPropertyChanged(_ problemFactOrEntity: Any) {
        callsTo_beforeProblemPropertyChanged.append(problemFactOrEntity)
        /* Do nothing */
    }
    
    var callsTo_afterProblemPropertyChanged = [Any]()
    
    func afterProblemPropertyChanged(_ problemFactOrEntity: Any) {
        callsTo_afterProblemPropertyChanged.append(problemFactOrEntity)
        /* Do nothing */
    }
    
    var callsTo_beforeProblemFactRemoved = [Any]()
    
    func beforeProblemFactRemoved(_ problemFact: Any) {
        callsTo_beforeProblemFactRemoved.append(problemFact)
        /* Do nothing */
    }
    
    var callsTo_afterProblemFactRemoved = [Any]()
    
    func afterProblemFactRemoved(_ problemFact: Any) {
        callsTo_afterProblemFactRemoved.append(problemFact)
        /* Do nothing */
    }
    
    var mock_lookUpWorkingObject: ((_ externalObject: Any) -> Any)?
    
    func lookUpWorkingObject<E>(_ externalObject: E) -> E {
        guard let closure = mock_lookUpWorkingObject else {
            return illegalState("Not mocked method of ScoreDirector_Mock called!")
        }
        return closure(externalObject) as? E
            ?? illegalState(
                "Return value of mocked lookUpWorkingObject has to be of type \(E.self)!"
            )
    }
    
    func lookUpWorkingObjectOrReturnNull<E>(_ externalObject: E) -> E? {
        illegalState("Not mocked method of ScoreDirector_Mock called!")
    }
    
}
