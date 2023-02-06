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

extension RangeReplaceableCollection {
    
    /**
     Returns a collection that is derived from the original collection by removing all elements
     before the given index.
    
     - Parameter from: first index of the original collection that will be in the new collection.
    
     - Returns: a collection with all elements removed for which the index is smaller than the given
                index.
     */
    public subscript(from from: Int) -> Self {
        self[from, self.count]
    }
    
    /**
     Returns a collection that is derived from the original collection by removing all elements
     beginning with the given index.
     
     - Parameter to: first index of the original collection that will not be in the new collection.
     
     - Returns: a collection with all elements removed for which the index is greater than or equal
                to the given index.
     */
    public subscript(to to: Int) -> Self {
        self[0, to]
    }
    
    /**
     Returns a subcollection of the original collection, beginning with the first given index and
     removing the given number of elements from the end.
     
     - Parameter from: first index that will be in the new collection.
     - Parameter skipLast: number of elements that are cut from the end.
     
     - Returns: a collection with the given numbers of elements removed from the beginning and the
                end.
     */
    public subscript(from: Int, skipLast skipLast: Int) -> Self {
        self[from, count - skipLast]
    }
    
    /**
     Returns a subcollection of the original collection, beginning with the first given index up to
     (but excluding) the second given index.
    
     - Parameter from: first index that will be in the new collection.
     - Parameter to: first index that lies after the remaining collection.
    
     - Returns: a collection with all elements removed for which the index is less than the first
                index or greater equal the second index.
     */
    public subscript(_ from: Int, to: Int) -> Self {
        Self(enumerated().filter({ $0.0 >= from && $0.0 < to }).map({ $0.1 }))
    }
    
}
