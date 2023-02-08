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

extension KeyPath where Value : SPComparable {
    
    /**
     Returns a comparator using the given property to obtain the comparable values.
     
     - Parameter property: the property whose values get used for comparison.
     
     - Returns: a comparator using the given property.
     */
    static prefix func © (property: KeyPath) -> SPComparator<Root> {
        // swiftlint:disable:previous identifier_name
        return Comparators.by({ $0[keyPath: property] })
    }
    
}
