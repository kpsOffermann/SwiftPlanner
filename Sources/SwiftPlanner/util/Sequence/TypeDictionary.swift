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
 A dictionary with metatypes as keys.
 */
public class TypeDictionary<Value> {
    
    public typealias Key = Any.Type
    
    private var dictionary = [ObjectIdentifier:Value]()
    
    public subscript(key: Key) -> Value? {
        get {
            return dictionary[ObjectIdentifier(key)]
        }
        set {
            dictionary[ObjectIdentifier(key)] = newValue
        }
    }
    
}
