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

// Helper for Java-style equality checks. Usage of Equatable is preferable.
enum Equals {
    
    static func checkArray<T>(_ lhs: [T], _ rhs: [T], orElse fallback: (Any, Any) -> Bool) -> Bool {
        return lhs.count == rhs.count
            && zip(lhs, rhs).allSatisfy({ lElement, rElement in
                check(lElement, rElement, orElse: { fallback(lElement, rElement) })
            })
    }
    
    static func check(_ lhs: AnyObject, _ rhs: AnyObject) -> Bool {
        if let equatableLhs = lhs as? any Equatable {
            return equatableLhs.isEqual(to: rhs)
        }
        return ObjectIdentifier(lhs) == ObjectIdentifier(rhs)
    }
    
    static func check(_ lhs: Any, _ rhs: Any, orElse fallback: () -> Bool) -> Bool {
        if let equatableLhs = lhs as? any Equatable {
            return equatableLhs.isEqual(to: rhs)
        }
        return fallback()
    }
    
}
