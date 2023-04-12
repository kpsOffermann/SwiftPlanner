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

public final class DefaultProblemChangeDirector<Solution_ : PlanningSolution> : ProblemChangeDirector {

    private let scoreDirector: any InnerScoreDirector<Solution_, any Score>

    public init(scoreDirector: any InnerScoreDirector<Solution_, any Score>) {
        self.scoreDirector = scoreDirector
    }

    public func addEntity<Entity>(_ entity: Entity, via entityConsumer: (Entity) -> Void) {
        scoreDirector.beforeEntityAdded(entity)
        entityConsumer(entity)
        scoreDirector.afterEntityAdded(entity)
    }

    public func removeEntity<Entity>(_ entity: Entity, via entityConsumer: (Entity) -> Void) {
        let workingEntity = lookUpWorkingObjectOrFail(entity)
        scoreDirector.beforeEntityRemoved(workingEntity)
        entityConsumer(workingEntity)
        scoreDirector.afterEntityRemoved(workingEntity)
    }

    public func changeVariable<Entity>(
            entity: Entity,
            variableName: String,
            entityConsumer: (Entity) -> Void
    ) {
        let workingEntity = lookUpWorkingObjectOrFail(entity)
        scoreDirector.beforeVariableChanged(entity: workingEntity, variableName: variableName)
        entityConsumer(workingEntity)
        scoreDirector.afterVariableChanged(entity: workingEntity, variableName: variableName)
    }

    public func addProblemFact<ProblemFact>(
            _ problemFact: ProblemFact,
            via problemFactConsumer: (ProblemFact) -> Void
    ) {
        scoreDirector.beforeProblemFactAdded(problemFact)
        problemFactConsumer(problemFact);
        scoreDirector.afterProblemFactAdded(problemFact)
    }

    public func removeProblemFact<ProblemFact>(
            _ problemFact: ProblemFact,
            via problemFactConsumer: (ProblemFact) -> Void
    ) {
        let workingProblemFact = lookUpWorkingObjectOrFail(problemFact)
        scoreDirector.beforeProblemFactRemoved(workingProblemFact)
        problemFactConsumer(workingProblemFact);
        scoreDirector.afterProblemFactRemoved(workingProblemFact)
    }

    public func changeProblemProperty<EntityOrProblemFact>(
            _ problemFactOrEntity: EntityOrProblemFact,
            via problemFactOrEntityConsumer: (EntityOrProblemFact) -> Void
    ) {
        let workingEntityOrProblemFact = lookUpWorkingObjectOrFail(problemFactOrEntity)
        scoreDirector.beforeProblemPropertyChanged(workingEntityOrProblemFact)
        problemFactOrEntityConsumer(workingEntityOrProblemFact)
        scoreDirector.afterProblemPropertyChanged(workingEntityOrProblemFact)
    }

    public func lookUpWorkingObjectOrFail<EntityOrProblemFact>(
            _ externalObject: EntityOrProblemFact
    ) -> EntityOrProblemFact {
        return scoreDirector.lookUpWorkingObject(externalObject)
    }

    public func lookUpWorkingObject<EntityOrProblemFact>(
            _ externalObject: EntityOrProblemFact
    ) -> EntityOrProblemFact? {
        scoreDirector.lookUpWorkingObjectOrReturnNull(externalObject)
    }

    public func doProblemChange(_ problemChange: any ProblemChange<Solution_>) -> any Score {
        problemChange.doChange(
            workingSolution: scoreDirector.getWorkingSolution(),
            problemChangeDirector: self
        )
        scoreDirector.triggerVariableListeners()
        return scoreDirector.calculateScore()
    }
    
}
