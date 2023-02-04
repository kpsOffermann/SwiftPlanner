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
 * Bounds the possible {@link Score}s for a {@link PlanningSolution} as more and more variables are initialized
 * (while the already initialized variables don't change).
 *
 * @see InitializingScoreTrendLevel
 */
public class InitializingScoreTrend {

    public static func parseTrend(
            _ initializingScoreTrendString: String,
            levelsSize: Int
    ) -> InitializingScoreTrend {
        let trendTokens: [String] = initializingScoreTrendString.split("/");
        let tokenIsSingle = trendTokens.count == 1;
        assert(
            tokenIsSingle || trendTokens.count == levelsSize,
            "The initializingScoreTrendString (" + initializingScoreTrendString
                + ") doesn't follow the correct pattern ("
                + buildTrendPattern(levelsSize: levelsSize) + "):"
                + " the trendTokens length (" + trendTokens.count
                + ") differs from the levelsSize (" + levelsSize + ")."
        )
        return InitializingScoreTrend(
            trendLevels: (0..<levelsSize).map({
                let trendName = trendTokens[tokenIsSingle ? 0 : $0]
                return InitializingScoreTrendLevel(rawValue: trendName)
                    ?? assertionFailure("\(trendName) is not a valid InitializingScoreTrendLevel")
            })
        )
    }

    public static func buildUniformTrend(
            level trendLevel: InitializingScoreTrendLevel,
            levelsSize: Int
    ) -> InitializingScoreTrend {
        return .init(trendLevels: .init(repeating: trendLevel, count: levelsSize))
    }

    public static func buildTrendPattern(levelsSize: Int) -> String {
        return [String](repeating: "\(InitializingScoreTrendLevel.ANY)", count: levelsSize)
                    .joined(separator: "/")
    }

    // ************************************************************************
    // Fields, constructions, getters and setters
    // ************************************************************************

    private let trendLevels: [InitializingScoreTrendLevel]

    public init(trendLevels: [InitializingScoreTrendLevel]) {
        self.trendLevels = trendLevels
    }

    public func getTrendLevels() -> [InitializingScoreTrendLevel] {
        return trendLevels
    }

    // ************************************************************************
    // Complex methods
    // ************************************************************************

    public func getLevelsSize() -> Int {
        return trendLevels.count
    }

    public func isOnlyUp() -> Bool {
        return trendLevels.allSatisfy({ $0 == .ONLY_UP })
    }

    public func isOnlyDown() -> Bool {
        return trendLevels.allSatisfy({ $0 == .ONLY_DOWN })
    }

}
