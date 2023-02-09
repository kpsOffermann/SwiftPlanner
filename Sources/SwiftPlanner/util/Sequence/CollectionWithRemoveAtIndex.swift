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

public protocol CollectionWithRemoveAtIndex : Collection {
    
    mutating func remove(at index: Int) -> Element
    
}

extension CollectionWithRemoveAtIndex {
    
    /**
     Removes the first element from the array that satisfies the given predicate.
     
     - Remark: If there are more than one element satisfying the predicate, only one is removed.
     
     - Parameter removePredicate: the predicate to determine the element that is removed.
     
     - Returns: `true`, if an element was deleted, otherwise `false`.
     */
    public mutating func removeFirst(where removePredicate: (Element) -> Bool) -> Bool {
        for (index, element) in self.enumerated() where removePredicate(element) {
            _ = remove(at: index)
            return true
        }
        return false
    }
    
}

public extension CollectionWithRemoveAtIndex where Element : Equatable {
    
    /**
     Removes the given object from the array.
     
     - Remark: If there are more than one element equal to the given object, only one is removed.
     
     - Parameter toBeRemoved: the object whose equal is to be removed.
     
     - Returns: `true`, if an element was deleted, otherwise `false`.
     */
    mutating func removeFirstEqual(_ toBeRemoved: Element) -> Bool {
        return removeFirst(where: { $0 == toBeRemoved })
    }
    
}
