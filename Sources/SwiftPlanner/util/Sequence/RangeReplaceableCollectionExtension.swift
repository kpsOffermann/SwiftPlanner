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

extension RangeReplaceableCollection {
    
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
