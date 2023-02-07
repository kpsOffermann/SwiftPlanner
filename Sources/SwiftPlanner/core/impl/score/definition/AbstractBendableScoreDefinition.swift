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

public /*abstract*/ class AbstractBendableScoreDefinition<Score_ : Score> : AbstractScoreDefinition<Score_>/*, ScoreDefinition*/ {

    static func generateLevelLabels(
            hard hardLevelsSize: Int,
            soft softLevelsSize: Int
    ) -> [String] {
        assert(
            hardLevelsSize >= 0 && softLevelsSize >= 0,
            "The hardLevelsSize (" + hardLevelsSize + ") and softLevelsSize (" + softLevelsSize
                + ") should be positive."
        )
        return (0..<hardLevelsSize).map({ "hard " + $0 + " score" })
            + (0..<softLevelsSize).map({ "soft " + $0 + " score" })
    }

    let hardLevelsSize: Int
    let softLevelsSize: Int

    public init(hardLevelsSize: Int, softLevelsSize: Int) {
        self.hardLevelsSize = hardLevelsSize
        self.softLevelsSize = softLevelsSize
        super.init(
            levelLabels: Self.generateLevelLabels(hard: hardLevelsSize, soft: softLevelsSize)
        )
    }

    public func getHardLevelsSize() -> Int {
        return hardLevelsSize
    }

    public func getSoftLevelsSize() -> Int {
        return softLevelsSize
    }

    // ************************************************************************
    // Worker methods
    // ************************************************************************

    public override func getLevelsSize() -> Int {
        return hardLevelsSize + softLevelsSize
    }

    public func getFeasibleLevelsSize() -> Int {
        return hardLevelsSize
    }

    public override func isCompatibleArithmeticArgument<S : Score>(_ score: S) -> Bool {
        if super.isCompatibleArithmeticArgument(score),
                let bendableScore = score as? UBendableScore {
            return getLevelsSize() == bendableScore.levelsSize()
                    && getHardLevelsSize() == bendableScore.hardLevelsSize()
                    && getSoftLevelsSize() == bendableScore.softLevelsSize()
        }
        return false
    }
    
}
