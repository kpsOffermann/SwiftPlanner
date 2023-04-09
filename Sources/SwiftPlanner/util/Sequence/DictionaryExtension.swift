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

public extension Dictionary {
    
    /**
     Returns whether this dictionary contains the given key.
     
     - Parameter key: the key that is checked for being contained.
     
     - Returns: `true`, if an entry with the given key exists in this dictionary,
                 otherwise `false`.
     */
    func containsKey(_ key: Key) -> Bool {
        return self[key] != nil
        // return contains(where: { $0.key == key })
    }
    
    /**
     Returns whether this dictionary contains the given value.
     
     - Parameter value: the value that is checked for being contained.
     
     - Returns: `true`, if an entry with the given value exists in this dictionary,
                 otherwise `false`.
     */
    func containsValue(_ value: Value) -> Bool where Value : Equatable {
        return contains(where: { $0.value == value })
    }
    
}
