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

/**
 * @param <Solution_> the solution type, the class with the {@link PlanningSolution} annotation
 */
public /*abstract*/ class AbstractStepScope<Solution_, Score_ : Score> : JavaStringConvertible {

    public let stepIndex: Int

    public var score: Score_? = nil
    public var bestScoreImproved = false
    // Stays null if there is no need to clone it
    public var clonedSolution: Solution_? = nil

    public init(stepIndex: Int) {
        self.stepIndex = stepIndex
    }

    public /*abstract*/ func getPhaseScope() -> AbstractPhaseScope<Solution_, Score_> {
        isAbstractMethod(Self.self)
    }

    // ************************************************************************
    // Calculated methods
    // ************************************************************************

    public func getScoreDirector() -> any InnerScoreDirector<Solution_, Score_> {
        return getPhaseScope().getScoreDirector()
    }

    public func getWorkingSolution() -> Solution_ {
        return getPhaseScope().getWorkingSolution()
    }

    public func getWorkingRandom() -> RandomNumberGenerator {
        return getPhaseScope().getWorkingRandom()
    }

    public func createOrGetClonedSolution() -> Solution_ {
        if let result = clonedSolution {
            return result
        }
        let result = getScoreDirector().cloneWorkingSolution()
        clonedSolution = result
        return result
    }

    public func toString() -> String {
        return String(describing: Self.self) + "(" + stepIndex + ")"
    }

}
