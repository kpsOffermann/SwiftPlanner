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

// WIP: method bodies
/**
 Helper methods for metatypes.
 */
enum MetaTypes {

    /**
     Determines if the type represented by `superType` parameter is either the same as, or is a
     supertype of, the type represented by the `subType` parameter. It returns true if so; otherwise
     it returns false.
     Specifically, this method tests whether the type represented by the `subType` parameter can be
     converted to the type represented by the `superType` parameter via an identity conversion or
     via a widening reference conversion.
     
     - Parameter supertype: the type to be checked to be a super type.
     - Parameter subtype: the type to be checked to be a sub type.
     - Returns: true, if objects of the type `subtype` can be assigned to objects of type `superType`.
     */
    static func isAssignable(_ superType: Any.Type, from subType: Any.Type) -> Bool {
        return false // WIP
    }
    
    static func name(_ type: Any.Type) -> String {
        return String(describing: type)
    }

}
