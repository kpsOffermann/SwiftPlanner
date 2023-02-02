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

public final class ScoreUtil {
    
    public static let INIT_LABEL = "init"
    public static let HARD_LABEL = "hard"
    public static let MEDIUM_LABEL = "medium"
    public static let SOFT_LABEL = "soft"
    public static let LEVEL_SUFFIXES = [ HARD_LABEL, SOFT_LABEL ]
    
    public static func parseScoreTokens<S : Score>(
            _ scoreClass: S.Type,
            _ scoreString: String,
            _ levelSuffixes: String...
    ) -> [String] {
        var scoreTokens = [String](repeating: "", count: levelSuffixes.count + 1)
        let suffixedScoreTokens: [String] = scoreString.split("/")
        var startIndex: Int = 0
        if suffixedScoreTokens.count == levelSuffixes.count + 1 {
            let suffixedScoreToken = suffixedScoreTokens[0]
            assert(
                suffixedScoreToken.hasSuffix(INIT_LABEL),
                parseScoreTokensErrorMessageBase(scoreClass, scoreString, levelSuffixes)
                    + " the suffixedScoreToken (" + suffixedScoreToken
                    + ") does not end with levelSuffix (" + INIT_LABEL + ")."
            )
                
            scoreTokens[0] = suffixedScoreToken[0, suffixedScoreToken.count - INIT_LABEL.count]
            startIndex = 1;
        }
        
        assert(
            suffixedScoreTokens.count == levelSuffixes.count,
            parseScoreTokensErrorMessageBase(scoreClass, scoreString, levelSuffixes)
                + " the suffixedScoreTokens length (\(suffixedScoreTokens.count)) differs from the levelSuffixes length (\(levelSuffixes.count) or \(levelSuffixes.count + 1))."
        )
        scoreTokens[0] = "0";
        startIndex = 0;

        for (i, levelSuffix) in levelSuffixes.enumerated() {
            let suffixedScoreToken: String = suffixedScoreTokens[startIndex + i]
            assert(
                suffixedScoreToken.hasSuffix(levelSuffix),
                parseScoreTokensErrorMessageBase(scoreClass, scoreString, levelSuffixes)
                    + " the suffixedScoreToken (" + suffixedScoreToken
                    + ") does not end with levelSuffix (" + levelSuffix + ")."
            )
            scoreTokens[1 + i] = suffixedScoreToken[0, suffixedScoreToken.count - levelSuffix.count]
        }
        return scoreTokens;
    }
    
    private static func parseScoreTokensErrorMessageBase<S : Score>(
            _ scoreClass: S.Type,
            _ scoreString: String,
            _ levelSuffixes: [String]
    ) -> String {
        return "The scoreString (\(scoreString)) for the scoreClass (\(String(describing: scoreClass))) doesn't follow the correct pattern (\(buildScorePattern(bendable: false, levelSuffixes))):"
    }
    
    public static func parseInitScore<S : Score>(
            _ scoreClass: S.Type,
            _ scoreString: String,
            _ initScoreString: String
    ) -> Int {
        return Int(initScoreString) ?? assertionFailure(
            "The scoreString (\(scoreString)) for the scoreClass (\(String(describing: scoreClass))) has a initScoreString ("
                    + initScoreString + ") which is not a valid integer."
        )
    }
    
    public static func parseLevelAsInt<S : Score>(
            _ scoreClass: S.Type,
            _ scoreString: String,
            _ levelString: String
    ) -> Int {
        if levelString == "*" {
            return Int.min
        }
        return Int(levelString) ?? assertionFailure(
            "The scoreString (\(scoreString)) for the scoreClass (\(String(describing: scoreClass))) has a levelString (" + levelString
                    + ") which is not a valid integer."
        )
    }
    
    public static func buildScorePattern(bendable: Bool, _ levelSuffixes: String...) -> String {
        buildScorePattern(bendable: bendable, levelSuffixes)
    }
    
    public static func buildScorePattern(bendable: Bool, _ levelSuffixes: [String]) -> String {
        var result = ""
        var first = true;
        for levelSuffix in levelSuffixes {
            if (first) {
                first = false;
            } else {
                result.append("/")
            }
            result.append(bendable ? "[999/.../999]" : "999")
            result.append(levelSuffix)
        }
        return result
    }
    
    public static func getInitPrefix(_ initScore: Int) -> String {
        if (initScore == 0) {
            return ""
        }
        return String(initScore) + INIT_LABEL + "/"
    }
    
    public static func buildShortString<S : Score>(
            score: S,
            notZero: (Number) -> Bool,
            levelLabels: String...
    ) -> String {
        let initScore = score.initScore()
        var shortString = ""
        if (initScore != 0) {
            shortString.append(initScore)
            shortString.append(INIT_LABEL)
        }
        for (i, levelNumber) in score.toLevelNumbers().enumerated() {
            if (notZero(levelNumber)) {
                if (!shortString.isEmpty) {
                    shortString.append("/");
                }
                shortString.append(levelNumber)
                shortString.append(levelLabels[i])
            }
        }
        if (shortString.isEmpty) {
            // Even for BigDecimals we use "0" over "0.0" because different levels can have different scales
            return "0"
        }
        return shortString
    }
    
}
