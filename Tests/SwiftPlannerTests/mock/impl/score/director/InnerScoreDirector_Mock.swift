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
class InnerScoreDirector_Mock<
        Solution_ : PlanningSolution,
        Score_ : Score
> : ScoreDirector_Mock<Solution_>, InnerScoreDirector {
    
    func setWorkingSolution(_ workingSolution: Solution_) {
        illegalState("Not mocked method of \(Self.self) called!")
    }
    
    func calculateScore() -> Score_ {
        illegalState("Not mocked method of \(Self.self) called!")
    }
    
    public func isConstraintMatchEnabled() -> Bool {
        illegalState("Not mocked method of \(Self.self) called!")
    }
    
    @available(macOS 13.0.0, *)
    func getConstraintMatchTotalMap() -> [String:any ConstraintMatchTotal<Score_>] {
        illegalState("Not mocked method of \(Self.self) called!")
    }
    
    @available(macOS 13.0.0, *)
    func getIndictmentMap() -> [AnyHashable:any Indictment<Score_>] {
        illegalState("Not mocked method of \(Self.self) called!")
    }
    
    public func overwriteConstraintMatchEnabledPreference(
            _ constraintMatchEnabledPreference: Bool
    ) {
        illegalState("Not mocked method of \(Self.self) called!")
    }
    
    public func getWorkingEntityListRevision() -> Int64 {
        illegalState("Not mocked method of \(Self.self) called!")
    }
    
    func doAndProcessMove(_ move: any Move<Solution_>, assertMoveScoreFromScratch: Bool) -> Score_ {
        illegalState("Not mocked method of \(Self.self) called!")
    }
    
    func doAndProcessMove(
            _ move: any Move<Solution_>,
            assertMoveScoreFromScratch: Bool,
            moveProcessor: (Score_) -> Void
    ) {
        illegalState("Not mocked method of \(Self.self) called!")
    }
    
    public func isWorkingEntityListDirty(
            expectedRevision expectedWorkingEntityListRevision: Int64
    ) -> Bool {
        illegalState("Not mocked method of \(Self.self) called!")
    }
    
    public func requiresFlushing() -> Bool {
        illegalState("Not mocked method of \(Self.self) called!")
    }
    
    func getScoreDirectorFactory() -> any InnerScoreDirectorFactory<Solution_, Score_> {
        illegalState("Not mocked method of \(Self.self) called!")
        fatalError()
    }
    
    func getSolutionDescriptor() -> SolutionDescriptor<Solution_, Score_> {
        illegalState("Not mocked method of \(Self.self) called!")
    }
    
    func getScoreDefinition() -> any ScoreDefinition<Score_> {
        illegalState("Not mocked method of \(Self.self) called!")
        fatalError()
    }
    
    func cloneWorkingSolution() -> Solution_ {
        illegalState("Not mocked method of \(Self.self) called!")
    }
    
    func cloneSolution(_ originalSolution: Solution_) -> Solution_ {
        illegalState("Not mocked method of \(Self.self) called!")
    }
    
    public func getCalculationCount() -> UInt64 {
        illegalState("Not mocked method of \(Self.self) called!")
    }
    
    public func resetCalculationCount() {
        illegalState("Not mocked method of \(Self.self) called!")
    }
    
    public func getSupplyManager() -> SupplyManager {
        illegalState("Not mocked method of \(Self.self) called!")
    }
    
    public func clone() -> Self {
        illegalState("Not mocked method of \(Self.self) called!")
    }
    
    func createChildThreadScoreDirector(
            type childThreadType: ChildThreadType
    ) -> any InnerScoreDirector<Solution_, Score_> {
        illegalState("Not mocked method of \(Self.self) called!")
        fatalError()
    }
    
    public func setAllChangesWillBeUndoneBeforeStepEnds(
            _ allChangesWillBeUndoneBeforeStepEnds: Bool
    ) {
        illegalState("Not mocked method of \(Self.self) called!")
    }
    
    func assertExpectedWorkingScore(
            _ expectedWorkingScore: Score_,
            completedAction: CustomStringConvertible?
    ) {
        illegalState("Not mocked method of \(Self.self) called!")
    }
    
    func assertShadowVariablesAreNotStale(
            expectedWorkingScore: Score_,
            completedAction: CustomStringConvertible?
    ) {
        illegalState("Not mocked method of \(Self.self) called!")
    }
    
    func assertWorkingScoreFromScratch(
            _ workingScore: Score_,
            completedAction: CustomStringConvertible?
    ) {
        illegalState("Not mocked method of \(Self.self) called!")
    }
    
    func assertPredictedScoreFromScratch(
            _ predictedScore: Score_,
            completedAction: CustomStringConvertible?
    ) {
        illegalState("Not mocked method of \(Self.self) called!")
    }
    
    func assertExpectedUndoMoveScore(move: any Move<Solution_>, beforeMoveScore: Score_) {
        illegalState("Not mocked method of \(Self.self) called!")
    }
    
    public func assertNonNullPlanningIds() {
        illegalState("Not mocked method of \(Self.self) called!")
    }
    
    public func close() {
        illegalState("Not mocked method of \(Self.self) called!")
    }
    
}
