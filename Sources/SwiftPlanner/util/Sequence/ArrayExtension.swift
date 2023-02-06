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

extension Array {
    
    // Make sure that the elements have a proper string representation.
    // This method is mostly for convenience for e.g. arrays where the elements are of protocol type
    // that conforms to CustomStringConvertible (because in that case Swift can't recognize the
    // conformance).
    func joinedToString2(separator: String = "") -> String {
        return map({"\($0)"}).joined(separator: separator)
    }
    
    /**
     Removes the first element from the array that satisfies the given predicate.
     
     - Remark: If there are more than one element satisfying the predicate, only one is removed.
     
     - Parameter removePredicate: the predicate to determine the element that is removed.
     
     - Returns: `true`, if an element was deleted, otherwise `false`.
     */
    public mutating func removeFirst(where removePredicate: (Element) -> Bool) -> Bool {
        for (index, element) in self.enumerated() where removePredicate(element) {
            remove(at: index)
            return true
        }
        return false
    }
    
    /**
     Sorts the array using the given comparator.
     
     - Parameter comparator: comparator to specify how to sort.
     */
    mutating func sort(_ comparator: SPComparator<Element>) {
        self.sort(by: { comparator($0, $1) != .orderedDescending })
    }
    
    /**
     Returns a new array with all elments sorted using the given comparator.
     
     - Parameter comparator: comparator to specify how to sort.
     
     - Returns: new array sorted with the given comparator.
     */
    func sorted(_ comparator: SPComparator<Element>) -> Self {
        return sorted(by: { comparator($0, $1) != .orderedDescending })
    }
    
}

extension Array where Element : CustomStringConvertible {
    
    func joinedToString(separator: String = "") -> String {
        return map({"\($0)"}).joined(separator: separator)
    }
    
}

extension Array where Element : Equatable {
    
    /**
     Removes the given object from the array.
     
     - Remark: If there are more than one element equal to the given object, only one is removed.
     
     - Parameter toBeRemoved: the object whose equal is to be removed.
     
     - Returns: `true`, if an element was deleted, otherwise `false`.
     */
    public mutating func removeFirstEqual(_ toBeRemoved: Element) -> Bool {
        return removeFirst(where: { $0 == toBeRemoved })
    }
    
}
