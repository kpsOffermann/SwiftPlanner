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

public extension Comparable where Self : SPComparable {
    
    func compare(to other: Self) -> ComparisonResult {
        if self == other {
            return .orderedSame
        }
        return self < other ? .orderedAscending : .orderedDescending
    }
    
}

public extension Comparable {
    
    func compare(to any: Any) -> ComparisonResult? {
        guard let other = any as? Self else {
            return nil
        }
        return compare(to: other)
    }
    
}
