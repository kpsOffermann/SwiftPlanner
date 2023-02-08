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
 */

import Foundation

enum Comparators {
    
    /**
     Returns a comparator that compares the two objects by comparing the value computed by the given
     map for each of the objects.
     
     - Parameter map: the compare criterium: method to compute the value that is used to compare.
     
     - Returns: a comparator that compares objects based on the values computed by the given map.
     */
    static func by<T, C : SPComparable>(_ map: @escaping (T) -> C) -> SPComparator<T> {
        return {
            C.compare(map($0), map($1))
        }
    }
    
    static func by<T, C>(
            _ map: @escaping (T) -> C,
            orElse fallback: @escaping () -> ComparisonResult
    ) -> SPComparator<T> {
        return {
            if let lhs = map($0) as? any SPComparable {
                return lhs.compare(to: map($1), orElse: fallback)
            }
            return fallback()
        }
    }
    
    /**
     Returns a comparator that compares the two objects by elementwise comparing the array computed
     by the given map for each of the objects.
     
     - Parameter map: the compare criterium: method to compute the array that is used to compare.
     
     - Returns: a comparator that elementwise compares objects based on the arrays computed by the
                given map.
     */
    static func elementwiseBy<T, C : SPComparable>(_ map: @escaping (T) -> [C]) -> SPComparator<T> {
        return {
            for (lhs, rhs) in zip(map($0), map($1)) {
                let result = C.compare(lhs, rhs)
                if result != .orderedSame {
                    return result
                }
            }
            return .orderedSame
        }
    }
    
    /**
     Returns a comparator that compares the two objects by elementwise comparing the array computed
     by the given map for each of the objects.
     
     - Parameter map: the compare criterium: method to compute the array that is used to compare.
     
     - Returns: a comparator that elementwise compares objects based on the arrays computed by the
                given map.
     */
    static func elementwiseBy<T, C : SPComparable>(_ property: KeyPath<T, [C]>) -> SPComparator<T> {
        return elementwiseBy({ $0[keyPath: property] })
    }
    
    static func withFallback<T>(
            _ fallback: @escaping () -> ComparisonResult
    ) -> SPComparator<T> where T : SPComparable {
        return {
            $0.compare(to: $1, orElse: fallback)
        }
    }
    
}
