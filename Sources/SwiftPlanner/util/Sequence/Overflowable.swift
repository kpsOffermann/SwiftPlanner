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

/**
 An Overflowable is a collection type for which the indices can overflow.
 */
protocol Overflowable {
    
    /// Type of the elements.
    associatedtype OverflowElement
    
    /**
     Accesses the element at the specified position.
     
     - Parameter index: the position of the element to access.
     
     - Returns: the element at the specified position.
     */
    subscript(_ index: Int) -> OverflowElement { get set }
    
    /// - Returns: the number of elements.
    var count: Int { get }
    
}

/**
 Extends Overflowable with convenience subscript methods.
 */
extension Overflowable {
    
    /**
     If the overflowable is not-empty, returns an index that is within the bounds of this
     overflowable. It is created by overflowing the given index.
     
     The returned index is the given index modulo the count of the overflowable.
     
     - Remark: Naturally, for an empty overflowable, the returned index is not within the bounds of
               the overflowable, since the bounds of an empty overflowable are empty.
     
     - Parameter overflowingIndex: the element index to be accessed.
     
     - Return: iff the overflowable is not-empty, an index that is within the bounds of the
               overflowable, otherwise the given index.
     */
    private func overflow(_ overflowingIndex: Int) -> Int {
        return Math.modulo(of: overflowingIndex, by: count)
    }
    
    /**
     Grants each not-empty overflowable access with a secured index that is within the bounds of the
     overflowable.
     If the given index is not within the bounds of the overflowable, it is overflown to become
     within the bounds.
     
     The actual used index is thus the given index modulo the count of the overflowable.
     
     - Remark: Naturally, for an empty overflowable, still every index will cause an index out of
               bounds exception.
     
     - Parameter overIndex: the element index to be accessed.
     
     - Returns: the element at the given index modulo the count of the overflowable.
     */
    subscript(mod overIndex: Int) -> OverflowElement {
        get {
            return self[overflow(overIndex)]
        }
        set(newValue) {
            self[overflow(overIndex)] = newValue
        }
    }
    
}
