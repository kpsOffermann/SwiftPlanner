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

// WIP: currently contains only methods that are used somewhere else
/* WIP: requires Annotation for
        getAnnotation
 */

public protocol MemberAccessor : AnyObject {
    
    func getName() -> String
    
    func getType() -> Any.Type
    
    func executeGetter(_ bean: Any) -> Any?
    
    func executeSetter(bean: Any, value: Any) // WIP: check whether nil is possible for value
    
    /**
     * As defined in {@link AnnotatedElement#getAnnotation(Class)}.
     */
    func getAnnotation<T/* : Annotation*/>(_ annotationClass: T.Type) -> T
    
}

public extension Set where Element == HashWrappedMemberAccessor {
    
    mutating func insert(_ element: MemberAccessor) {
        insert(HashWrappedMemberAccessor(element))
    }
    
    func contains(_ element: MemberAccessor) -> Bool {
        return contains(HashWrappedMemberAccessor(element))
    }
    
}

public class HashWrappedMemberAccessor : Equatable, Hashable {
    
    let accessor: MemberAccessor
    
    public init(_ accessor: MemberAccessor) {
        self.accessor = accessor
    }
    
    public static func == (lhs: HashWrappedMemberAccessor, rhs: HashWrappedMemberAccessor) -> Bool {
        return lhs.accessor === rhs.accessor
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(accessor))
    }
    
}
