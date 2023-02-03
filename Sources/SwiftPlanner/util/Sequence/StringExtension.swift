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

 NOTICE: This file is based on the optaPlanner engine by kiegroup 
         (https://github.com/kiegroup/optaplanner), which is licensed 
         under the Apache License, Version 2.0, too. Furthermore, this
         file has been modified including (but not necessarily
         limited to) translating the original file to Swift.
 */

extension String {
    
    mutating func append(_ int: Int) {
        append(String(int))
    }
    
    mutating func append(_ number: Number) {
        append(number.toString())
    }
    
    func int(of index: String.Index) -> Int {
        return distance(from: startIndex, to: index)
    }
    
    func index(of element: Character) -> Int? {
        return int.?(firstIndex(of: element))
    }
    
    /**
     Returns the first index where the specified substring appears in the string.
     
     - Parameter substring: A substring to search for in the collection.
     - Returns: The first index where `substring` is found. If `substring` is not
       found in the string, returns `nil`.
     */
    func index(of substring: String, after fromIndex: Int = 0) -> Int? {
        guard let first = substring.first else {
            return fromIndex < count ? fromIndex : nil
        }
        let tail = substring[from: 1]
        var remainingString = self[from: fromIndex]
        while !remainingString.isEmpty {
            guard let start = remainingString.index(of: first) else {
                return nil
            }
            remainingString = remainingString[from: start + 1]
            if remainingString.hasPrefix(tail) {
                return start
            }
        }
        return nil
    }
    
    func split(_ separator: Character) -> [String] {
        return split(separator: separator).map({ String($0) })
    }
    
    /**
     Returns the longest possible substrings of the string, in order, around elements equal to the
     given separator. The resulting array consists of at most `maxSplits + 1` substrings.
     Elements that are used to split the collection are not returned as part of any substring.
     
     - See also: String.split(separator:)
     
     - Parameter separator: the element that should be split upon.
     - Parameter maxSplits: the maximum number of times to split the string, ie one less than the
                            number of substrings to return. If `maxSplits + 1` substrings are
                            returned, the last one is a suffix of the original string containing
                            the remaining elements. `maxSplits` must be greater than or equal to
                            zero. The default value is `Int.max`.
     - Parameter omittingEmptySubsequences: if `false`, an empty substring is returned in the
                                            result for each consecutive pair of `separator` elements
                                            in the string and for each instance of `separator` at
                                            the start or end of the collection. If `true`, only
                                            nonempty substrings are returned. The default value is
                                            `true`.
    
     - Returns: an array of substrings, split from this string's elements.
     */
    func split(
           at separator: String,
           maxSplits: Int = .max,
           omittingEmptySubsequences: Bool = true
    ) -> [String] {
        var result = [String]()
        var remaining = self
        outerLoop: while remaining.count >= separator.count {
            for index in 0 ..< remaining.count - separator.count + 1 {
                if remaining[from: index].hasPrefix(separator) {
                    result.append(remaining[to: index])
                    remaining = remaining[from: index + separator.count]
                    continue outerLoop
                }
            }
            break
        }
        result.append(remaining)
        if !omittingEmptySubsequences {
            return result
        }
        return result.filter({ !$0.isEmpty })
    }
    
    static func +(lhs: String, rhs: CustomStringConvertible) -> String {
        return lhs + "\(rhs)"
    }
    
}
