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
 * This {@link Score} is based on 2 levels of int constraints: hard and soft.
 * Hard constraints have priority over soft constraints.
 * Hard constraints determine feasibility.
 * <p>
 * This class is immutable.
 *
 * @see Score
 */
public final class HardSoftScore : Score {

    public static let ZERO = HardSoftScore(init: 0, hard: 0, soft: 0)
    public static let ONE_HARD = HardSoftScore(init: 0, hard: 1, soft: 0)
    public static let ONE_SOFT = HardSoftScore(init: 0, hard: 0, soft: 1)

    public static func parseScore(_ scoreString: String) -> HardSoftScore {
        let scoreTokens: [String] = ScoreUtil.parseScoreTokens(
            HardSoftScore.self,
            scoreString,
            ScoreUtil.HARD_LABEL,
            ScoreUtil.SOFT_LABEL
       )
        let initScore = ScoreUtil.parseInitScore(
            HardSoftScore.self,
            scoreString,
            scoreTokens[0]
        )
        let hardScore = ScoreUtil.parseLevelAsInt(
            HardSoftScore.self,
            scoreString,
            scoreTokens[1]
        )
        let softScore = ScoreUtil.parseLevelAsInt(
            HardSoftScore.self,
            scoreString,
            scoreTokens[3]
        )
        return ofUninitialized(init: initScore, hard: hardScore, soft: softScore)
    }

    public static func ofUninitialized(
            init initScore: Int,
            hard hardScore: Int,
            soft softScore: Int
    ) -> HardSoftScore {
        return HardSoftScore(init: initScore, hard: hardScore, soft: softScore)
    }

    public static func of(hard hardScore: Int, soft softScore: Int) -> HardSoftScore {
        return HardSoftScore(init: 0, hard: hardScore, soft: softScore)
    }

    public static func ofHard(_ hardScore: Int) -> HardSoftScore{
        return of(hard: hardScore, soft: 0)
    }

    public static func ofSoft(_ softScore: Int) -> HardSoftScore {
        return of(hard: 0, soft: softScore)
    }

    // ************************************************************************
    // Fields
    // ************************************************************************

    private let _initScore: Int
    private let _hardScore: Int
    private let _softScore: Int

    private convenience init() {
        self.init(init: Int.min, hard: Int.min, soft: Int.min)
    }

    private init(init initScore: Int, hard hardScore: Int, soft softScore: Int) {
        self._initScore = initScore;
        self._hardScore = hardScore;
        self._softScore = softScore;
    }

    public func initScore() -> Int {
        return _initScore
    }

    /**
     * The total of the broken negative hard constraints and fulfilled positive hard constraints.
     * Their weight is included in the total.
     * The hard score is usually a negative number because most use cases only have negative constraints.
     *
     * @return higher is better, usually negative, 0 if no hard constraints are broken/fulfilled
     */
    public func hardScore() -> Int {
        return _hardScore
    }

    /**
     * The total of the broken negative soft constraints and fulfilled positive soft constraints.
     * Their weight is included in the total.
     * The soft score is usually a negative number because most use cases only have negative constraints.
     * <p>
     * In a normal score comparison, the soft score is irrelevant if the 2 scores don't have the same hard and medium score.
     *
     * @return higher is better, usually negative, 0 if no soft constraints are broken/fulfilled
     */
    public func softScore() -> Int {
        return _softScore
    }

    // ************************************************************************
    // Worker methods
    // ************************************************************************

    public func withInitScore(_ newInitScore: Int) -> Self {
        return Self(init: newInitScore, hard: _hardScore, soft: _softScore)
    }

    /**
     * A {@link PlanningSolution} is feasible if it has no broken hard constraints.
     *
     * @return true if the {@link #hardScore()} is 0 or higher
     */
    public func isFeasible() -> Bool {
        return _initScore >= 0 && _hardScore >= 0
    }

    public func add(_ addend: HardSoftScore) -> Self {
        return Self(
            init: _initScore + addend.initScore(),
            hard: _hardScore + addend.hardScore(),
            soft: _softScore + addend.softScore()
        )
    }

    public func subtract(_ subtrahend: HardSoftScore) -> Self {
        return Self(
            init: _initScore - subtrahend.initScore(),
            hard: _hardScore - subtrahend.hardScore(),
            soft: _softScore - subtrahend.softScore()
        )
    }

    public func multiply(_ multiplicand: Double) -> Self {
        return Self(
            init: Int(floor(Double(_initScore) * multiplicand)),
            hard: Int(floor(Double(_hardScore) * multiplicand)),
            soft: Int(floor(Double(_softScore) * multiplicand))
        )
    }

    public func divide(_ divisor: Double) -> Self {
        return Self(
            init: Int(floor(Double(_initScore) / divisor)),
            hard: Int(floor(Double(_hardScore) / divisor)),
            soft: Int(floor(Double(_softScore) / divisor))
        )
    }

    public func power(_ exponent: Double) -> Self {
        return Self(
            init: Int(floor(pow(Double(_initScore), exponent))),
            hard: Int(floor(pow(Double(_hardScore), exponent))),
            soft: Int(floor(pow(Double(_softScore), exponent)))
        )
    }

    public func abs() -> Self {
        return Self(
            init: Swift.abs(_initScore),
            hard: Swift.abs(_hardScore),
            soft: Swift.abs(_softScore)
        )
    }
    
    public func zero() -> Self {
        return Self(init: 0, hard: 0, soft: 0)
    }
    
    public func toLevelNumbers() -> [Number] {
        return [ _hardScore, _softScore ]
    }

    public static func ==(lhs: HardSoftScore, rhs: HardSoftScore) -> Bool {
        return lhs.initScore() == rhs.initScore()
            && lhs.hardScore() == rhs.hardScore()
            && lhs.softScore() == rhs.softScore()
    }
    
    public func equals(o: Any) -> Bool {
        if let other = o as? HardSoftScore {
            return self == other
        } else {
            return false
        }
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(_initScore)
        hasher.combine(_hardScore)
        hasher.combine(_softScore)
    }

    public static func <(lhs: HardSoftScore, rhs: HardSoftScore) -> Bool {
        return lhs.compareTo(rhs) < 0
    }
    
    public func compareTo(_ other: HardSoftScore) -> Int {
        if (_initScore != other.initScore()) {
            return _initScore - other.initScore()
        } else if (_hardScore != other.hardScore()) {
            return _hardScore - other.hardScore()
        } else {
            return _softScore - other.softScore()
        }
    }

    public func toShortString() -> String {
        return ScoreUtil.buildShortString(
            score: self,
            notZero: { $0.toInt() != 0 },
            levelLabels: ScoreUtil.HARD_LABEL,
            ScoreUtil.SOFT_LABEL
        )
    }
    
    public var description: String {
        return toString()
    }

    public func toString() -> String{
        return ScoreUtil.getInitPrefix(_initScore) + _hardScore + ScoreUtil.HARD_LABEL + "/"
            + _softScore + ScoreUtil.SOFT_LABEL
    }

}
