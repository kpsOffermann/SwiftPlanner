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

public extension StringProtocol {
    
    /**
     Returns the element at the given index.
     
     - Parameter index: the index of the returned element.
     
     - Returns: the element at the given index; or nil if the index is out of bounds.
     */
    subscript(_ index: Int) -> Element? {
        let sIndex = self.index(startIndex, offsetBy: index)
        return indices.contains(sIndex) ? self[sIndex] : nil
    }
    
}
