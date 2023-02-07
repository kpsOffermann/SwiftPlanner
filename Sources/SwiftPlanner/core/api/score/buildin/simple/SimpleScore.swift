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
 * This {@link Score} is based on 1 level of int constraints.
 * <p>
 * This class is immutable.
 *
 * @see Score
 */
public final class SimpleScore : Score, JavaComparable, JavaStringConvertible {

    public static let ZERO = SimpleScore(initScore: 0, score: 0)
    public static let ONE = SimpleScore(initScore: 0, score: 1)

    public static func parseScore(_ scoreString: String) -> Score_{
        let scoreTokens = ScoreUtil.parseScoreTokens(SimpleScore.self, scoreString, "")
        let initScore = ScoreUtil.parseInitScore(SimpleScore.self, scoreString, scoreTokens[0])
        let score = ScoreUtil.parseLevelAsInt(SimpleScore.self, scoreString, scoreTokens[1])
        return ofUninitialized(initScore: initScore, score: score)
    }

    public static func ofUninitialized(initScore: Int, score: Int) -> SimpleScore {
        return SimpleScore(initScore: initScore, score: score)
    }

    public static func of(_ score: Int) -> SimpleScore {
        return SimpleScore(initScore: 0, score: score)
    }

    // ************************************************************************
    // Fields
    // ************************************************************************

    public let _initScore: Int
    public let _score: Int

    /**
     * Private default constructor for default marshalling/unmarshalling of unknown frameworks that use reflection.
     * Such integration is always inferior to the specialized integration modules, such as
     * optaplanner-persistence-jpa, optaplanner-persistence-jackson, optaplanner-persistence-jaxb, ...
     */
    private convenience init() {
        self.init(initScore: Int.min, score: Int.min)
    }

    private init(initScore: Int, score: Int) {
        self._initScore = initScore
        self._score = score
    }
    
    public func initScore() -> Int {
        return _initScore
    }
    
    /**
     * The total of the broken negative constraints and fulfilled positive constraints.
     * Their weight is included in the total.
     * The score is usually a negative number because most use cases only have negative constraints.
     *
     * @return higher is better, usually negative, 0 if no constraints are broken/fulfilled
     */
    public func score() -> Int {
        return _score
    }

    // ************************************************************************
    // Worker methods
    // ************************************************************************

    public func withInitScore(_ newInitScore: Int) -> Score_ {
        return SimpleScore(initScore: newInitScore, score: _score)
    }

    public func add(_ addend: Score_) -> Score_ {
        return SimpleScore(initScore: _initScore + addend._initScore, score: _score + addend._score)
    }

    public func subtract(_ subtrahend: Score_) -> Score_ {
        return SimpleScore(
            initScore: _initScore - subtrahend._initScore,
            score: _score - subtrahend._score
        )
    }

    public func multiply(_ multiplicand: Double) -> Score_ {
        let multiplied: (Int) -> Int = { Int(floor(Double($0) * multiplicand)) }
        return SimpleScore(initScore: multiplied(_initScore), score: multiplied(_score))
    }

    public func divide(_ divisor: Double) -> Score_ {
        let divided: (Int) -> Int = { Int(floor(Double($0) / divisor)) }
        return SimpleScore(initScore: divided(_initScore), score: divided(_score))
    }

    public func power(_ exponent: Double) -> Score_ {
        let powed: (Int) -> Int = { Int(floor(pow(Double($0), exponent))) }
        return SimpleScore(initScore: powed(_initScore), score: powed(_score))
    }

    public func abs() -> Score_ {
        return SimpleScore(initScore: Swift.abs(_initScore), score: Swift.abs(_score))
    }

    public func zero() -> Score_ {
        return SimpleScore.ZERO;
    }

    public func isFeasible() -> Bool {
        return _initScore >= 0
    }

    public func toLevelNumbers() -> [Number] {
        return [ _score ]
    }

    public static func == (lhs: SimpleScore, rhs: SimpleScore) -> Bool {
        return lhs._initScore == rhs._initScore && lhs._score == rhs._score
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(_initScore)
        hasher.combine(_score)
    }

    public func compareTo(_ other: SimpleScore) -> Int {
        if (_initScore != other._initScore) {
            return Int.compare(_initScore, other._initScore);
        } else {
            return Int.compare(_score, other._score);
        }
    }

    public func toShortString() -> String {
        return ScoreUtil.buildShortString(score: self, notZero: { $0.toInt() != 0 }, levelLabels: "")
    }

    public func toString() -> String {
        return ScoreUtil.getInitPrefix(_initScore) + _score;
    }

}
