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

import Foundation

/**
 * Abstract superclass for {@link ScoreDefinition}.
 *
 * @see ScoreDefinition
 * @see HardSoftScoreDefinition
 */
public /*abstract*/ class AbstractScoreDefinition<Score_ : Score> /*: ScoreDefinition*/ {

    private let levelLabels: [String]

    static func sanitize(_ number: Int) -> Int {
        return number == 0 ? 1 : number
    }

    static func sanitize(_ number: Int64) -> Int64 {
        return number == 0 ? 1 : number
    }

    static func divide(_ dividend: Int, by divisor: Int) -> Int {
        return Int(floor(divide(Double(dividend), by: Double(divisor))))
    }

    static func divide(_ dividend: Int64, by divisor: Int64) -> Int64 {
        return Int64(floor(divide(Double(dividend), by: Double(divisor))))
    }

    static func divide(_ dividend: Double, by divisor: Double) -> Double {
        return dividend / divisor
    }

    /**
     * @param levelLabels never null, as defined by {@link ScoreDefinition#getLevelLabels()}
     */
    public init(levelLabels: [String]) {
        self.levelLabels = levelLabels
        assertOverridden(AbstractScoreDefinition.self, self)
    }

    public func getInitLabel() -> String {
        return "init score"
    }

    
    public func getLevelsSize() -> Int {
        return levelLabels.count
    }

    public func getLevelLabels() -> [String] {
        return levelLabels
    }

    public func formatScore(_ score: Score_) -> String {
        return score.description
    }

    public func isCompatibleArithmeticArgument<S : Score>(_ score: S) -> Bool {
        return type(of: score) == getScoreClass()
    }
    
    /* abstract */ func getScoreClass() -> Score_.Type {
        isAbstractMethod(Self.self)
    }

    public var description: String {
        return String(describing: type(of: self))
    }

}
