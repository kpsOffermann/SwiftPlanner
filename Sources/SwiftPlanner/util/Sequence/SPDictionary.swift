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
 A dictionary for not-hashable keys.
 
 If the keys are hashable, a conventional dictionary should be used.
 */
public class SPDictionary<Key, Value> {
    
    /**
     The types (keys) for which values are stored in this type dictionary paired with their object
     identifiers that are used as internal keys.
     */
    private var types = [Int:Key]()
    
    private var values = [Int:Value]()
    
    private let hash: (Key) -> Int
    
    public init(hashedBy hash: @escaping (Key) -> Int) {
        self.hash = hash
    }
    
    public subscript(key: Key) -> Value? {
        get {
            return values[hash(key)]
        }
        set {
            let hashValue = hash(key)
            types[hashValue] = key
            values[hashValue] = newValue
        }
    }
    
    /**
     All types stored in this dictionary.
     */
    public var keys: [Key] {
        types.map({ $0.value })
    }
    
    /**
     Returns the value of the given `key`, if the key is already present in the dictionary.
     Otherwise computes a new value from the given closure `orElse`, puts this value into the
     dictionary for the given key and returns the newly computed value.
     
     - Parameter key: the key whose value is returned.
     - Parameter orElse: method to compute a new value, if the given key does not have a value yet.
     
     - Returns: the value to the given `key` if it exists, otherwise the result of invoking `orElse`.
     */
    public func computeIfAbsent(_ key: Key, orElse: (Key) -> Value) -> Value {
        if let result = self[key] {
            return result
        }
        let result = orElse(key)
        self[key] = result
        return result
    }
    
    /**
     Returns the value of the given `key`, if the key is already present in the dictionary.
     Otherwise computes a new value from the given closure `orElse`, puts this value into the
     dictionary for the given key and returns the newly computed value.
     
     - Parameter key: the key whose value is returned.
     - Parameter orElse: method to compute a new value, if the given key does not have a value yet.
     
     - Returns: the value to the given `key` if it exists, otherwise the result of invoking `orElse`.
     */
    public func computeIfAbsent(_ key: Key, orElse: (Key) -> Value?) -> Value? {
        if let result = self[key] {
            return result
        }
        let result = orElse(key)
        self[key] = result
        return result
    }
    
}
