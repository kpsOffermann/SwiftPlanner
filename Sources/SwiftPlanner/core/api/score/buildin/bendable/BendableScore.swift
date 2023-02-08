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
 * This {@link Score} is based on n levels of int constraints.
 * The number of levels is bendable at configuration time.
 * <p>
 * This class is immutable.
 * <p>
 * The {@link #hardLevelsSize()} and {@link #softLevelsSize()} must be the same as in the
 * {@link BendableScoreDefinition} used.
 *
 * @see Score
 */
public final class BendableScore : IBendableScore, SPComparable {

    /**
     * @param scoreString never null
     * @return never null
     */
    public static func parseScore(_ scoreString: String) -> Self {
        let scoreTokens = ScoreUtil.parseBendableScoreTokens(BendableScore.self, scoreString)
        let initScore = ScoreUtil.parseInitScore(BendableScore.self, scoreString, scoreTokens[0][0])
        let hardScores = scoreTokens[1].map({
            ScoreUtil.parseLevelAsInt(BendableScore.self, scoreString, $0)
        })
        let softScores = scoreTokens[2].map({
            ScoreUtil.parseLevelAsInt(BendableScore.self, scoreString, $0)
        })
        return ofUninitialized(init: initScore, hards: hardScores, softs: softScores)
    }

    /**
     * Creates a new {@link BendableScore}.
     *
     * @param initScore see {@link Score#initScore()}
     * @param hardScores never null, never change that array afterwards: it must be immutable
     * @param softScores never null, never change that array afterwards: it must be immutable
     * @return never null
     */
    public static func ofUninitialized(
            init initScore: Int,
            hards hardScores: [Int],
            softs softScores: [Int]
    ) -> Self {
        return Self(init: initScore, hards: hardScores, softs: softScores)
    }

    /**
     * Creates a new {@link BendableScore}.
     *
     * @param hardScores never null, never change that array afterwards: it must be immutable
     * @param softScores never null, never change that array afterwards: it must be immutable
     * @return never null
     */
    public static func of(hards hardScores: [Int], softs softScores: [Int]) -> Self {
        return Self(init: 0, hards: hardScores, softs: softScores)
    }

    /**
     * Creates a new {@link BendableScore}.
     *
     * @param hardLevelsSize at least 0
     * @param softLevelsSize at least 0
     * @return never null
     */
    public static func zero(hardLevelsSize: Int, softLevelsSize: Int) -> Self {
        return Self(
            init: 0,
            hards: [Int](repeating: 0, count: hardLevelsSize),
            softs: [Int](repeating: 0, count: softLevelsSize)
        )
    }

    /**
     * Creates a new {@link BendableScore}.
     *
     * @param hardLevelsSize at least 0
     * @param softLevelsSize at least 0
     * @param hardLevel at least 0, less than hardLevelsSize
     * @param hardScore any
     * @return never null
     */
    public static func ofHard(
            hardLevelsSize: Int,
            softLevelsSize: Int,
            hardLevel: Int,
            hardScore: Int
    ) -> Self {
        var hardScores = [Int](repeating: 0, count: hardLevelsSize)
        hardScores[hardLevel] = hardScore;
        return Self(init: 0, hards: hardScores, softs: [Int](repeating: 0, count: softLevelsSize))
    }

    /**
     * Creates a new {@link BendableScore}.
     *
     * @param hardLevelsSize at least 0
     * @param softLevelsSize at least 0
     * @param softLevel at least 0, less than softLevelsSize
     * @param softScore any
     * @return never null
     */
    public static func ofSoft(
            hardLevelsSize: Int,
            softLevelsSize: Int,
            softLevel: Int,
            softScore: Int
    ) -> Self {
        var softScores = [Int](repeating: 0, count: softLevelsSize)
        softScores[softLevel] = softScore;
        return Self(init: 0, hards: [Int](repeating: 0, count: hardLevelsSize), softs: softScores)
    }

    // ************************************************************************
    // Fields
    // ************************************************************************

    private let _initScore: Int
    private let _hardScores: [Int]
    private let _softScores: [Int]

    private convenience init () {
        self.init(init: Int.min, hards: [], softs: [])
    }

    /**
     * @param initScore see {@link Score#initScore()}
     * @param hardScores never null
     * @param softScores never null
     */
    private init(init initScore: Int, hards hardScores: [Int], softs softScores: [Int]) {
        self._initScore = initScore;
        self._hardScores = hardScores;
        self._softScores = softScores;
    }

    public func initScore() -> Int {
        return _initScore
    }

    /**
     * @return not null, array copy because this class is immutable
     */
    public func hardScores() -> [Int] {
        return _hardScores
    }

    /**
     * @return not null, array copy because this class is immutable
     */
    public func softScores() -> [Int]{
        return _softScores
    }

    public func hardLevelsSize() -> Int {
        return _hardScores.count
    }

    /**
     * @param hardLevel {@code 0 <= hardLevel <} {@link #hardLevelsSize()}.
     *        The {@code scoreLevel} is {@code hardLevel} for hard levels and {@code softLevel + hardLevelSize} for soft levels.
     * @return higher is better
     */
    public func hardScore(level hardLevel: Int) -> Int {
        return _hardScores[hardLevel]
    }

    public func softLevelsSize() -> Int {
        return _softScores.count
    }

    /**
     * @param softLevel {@code 0 <= softLevel <} {@link #softLevelsSize()}.
     *        The {@code scoreLevel} is {@code hardLevel} for hard levels and {@code softLevel + hardLevelSize} for soft levels.
     * @return higher is better
     */
    public func softScore(level softLevel: Int) -> Int {
        return _softScores[softLevel]
    }

    // ************************************************************************
    // Worker methods
    // ************************************************************************

    public func withInitScore(_ newInitScore: Int) -> Self {
        return Self(init: newInitScore, hards: _hardScores, softs: _softScores)
    }

    /**
     * @param level {@code 0 <= level <} {@link #levelsSize()}
     * @return higher is better
     */
    public func hardOrSoftScore(level: Int) -> Int {
        if (level < _hardScores.count) {
            return _hardScores[level]
        } else {
            return _softScores[level - _hardScores.count]
        }
    }

    public func isFeasible() -> Bool {
        return _initScore >= 0 && _hardScores.allSatisfy({ $0 >= 0 })
    }

    public func add(_ addend: BendableScore) -> Self {
        validateCompatible(addend)
        return Self(
            init: _initScore + addend.initScore(),
            hards: zip(_hardScores, addend._hardScores).map(+),
            softs: zip(_softScores, addend._softScores).map(+)
        )
    }

    public func subtract(_ subtrahend: BendableScore) -> Self {
        validateCompatible(subtrahend)
        return Self(
            init: _initScore - subtrahend.initScore(),
            hards: zip(_hardScores, subtrahend._hardScores).map(-),
            softs: zip(_softScores, subtrahend._softScores).map(-)
        )
    }

    public func multiply(_ multiplicand: Double) -> Self {
        let multiplied: (Int) -> Int = { Int(floor(Double($0) * multiplicand)) }
        return Self(
            init: multiplied(_initScore),
            hards: _hardScores.map(multiplied),
            softs: _softScores.map(multiplied)
        )
    }

    public func divide(_ divisor: Double) -> Self {
        let divided: (Int) -> Int = { Int(floor(Double($0) / divisor)) }
        return Self(
            init: divided(_initScore),
            hards: _hardScores.map(divided),
            softs: _softScores.map(divided)
        )
    }

    public func power(_ exponent: Double) -> Self {
        let powed: (Int) -> Int = { Int(floor(pow(Double($0), exponent))) }
        return Self(
            init: powed(_initScore),
            hards: _hardScores.map(powed),
            softs: _softScores.map(powed)
        )
    }

    public func negate() -> Self { // Overridden as the default impl would create zero() all the time.
        return Self(init: -_initScore, hards: _hardScores.map(-), softs: _softScores.map(-))
    }

    public func abs() -> Self {
        return Self(
            init: Swift.abs(_initScore),
            hards: _hardScores.map(Swift.abs),
            softs: _softScores.map(Swift.abs)
        )
    }
    
    public func zero() -> Self {
        return Self.zero(hardLevelsSize: hardLevelsSize(), softLevelsSize: softLevelsSize())
    }

    public func toLevelNumbers() -> [Number] {
        return _hardScores + _softScores
    }

    public static func == (lhs: BendableScore, rhs: BendableScore) -> Bool {
        return lhs.hardLevelsSize() == rhs.hardLevelsSize()
            && lhs.softLevelsSize() == rhs.softLevelsSize()
            && lhs._initScore == rhs._initScore
            && zip(lhs._hardScores, rhs._hardScores).allSatisfy(==)
            && zip(lhs._softScores, rhs._softScores).allSatisfy(==)
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(_initScore)
        hasher.combine(_hardScores)
        hasher.combine(_softScores)
    }

    public func compare(to other: BendableScore) -> ComparisonResult {
        validateCompatible(other)
        return chainCompare(
            self,
            other,
            by: ©\._initScore,
            Comparators.elementwiseBy(\._hardScores),
            Comparators.elementwiseBy(\._softScores)
        )
    }

    public func toShortString() -> String {
        return ScoreUtil.buildBendableShortString(score: self, notZero: { $0.toInt() != 0 })
    }
    
    public var description: String {
        return toString()
    }

    public func toString() -> String {
        var s = ""
        s.append(ScoreUtil.getInitPrefix(_initScore))
        s.append("[")
        s.append(_hardScores.joinedToString(separator: "/"))
        s.append("]hard/[")
        s.append(_softScores.joinedToString(separator: "/"))
        s.append("]soft")
        return s
    }

    public func validateCompatible(_ other: BendableScore) {
        assert(
            hardLevelsSize() == other.hardLevelsSize(),
            "The score (" + self + ") with hardScoreSize (" + hardLevelsSize()
                + ") is not compatible with the other score (" + other
                + ") with hardScoreSize (" + other.hardLevelsSize() + ")."
        )
        assert(
            softLevelsSize() == other.softLevelsSize(),
            "The score (" + self + ") with softScoreSize (" + softLevelsSize()
                + ") is not compatible with the other score (" + other
                + ") with softScoreSize (" + other.softLevelsSize() + ")."
        )
    }

}
