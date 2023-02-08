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

public typealias SPComparator<T> = (T, T) -> ComparisonResult

// comparator operator (alt+g); use to transform any viable type into a comparator
prefix operator ©

func chainComparator<T>(_ comparators: [SPComparator<T>]) -> SPComparator<T> {
    return { lhs, rhs in
        for comparator in comparators {
            let comparison = comparator(lhs, rhs)
            if comparison != .orderedSame {
                return comparison
            }
        }
        return .orderedSame
    }
}

func chainCompare<T>(_ lhs: T, _ rhs: T, by comparators: SPComparator<T>...) -> ComparisonResult {
    chainComparator(comparators)(lhs, rhs)
}
