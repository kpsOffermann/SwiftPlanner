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

import Foundation

public class DescriptorPolicy {
    
    public var generatedSolutionClonerMap = [String:any SolutionCloner]()
    private var fromSolutionValueRangeProviderMap = [String:MemberAccessor]()
    private var anonymousFromSolutionValueRangeProviderSet = Set<HashWrappedMemberAccessor>()
    private var fromEntityValueRangeProviderMap = [String:MemberAccessor]()
    private var anonymousFromEntityValueRangeProviderSet = Set<HashWrappedMemberAccessor> ()
    public var domainAccessType = DomainAccessType.REFLECTION
    public private(set) var memberAccessorFactory: MemberAccessorFactory?

    public func addFromSolutionValueRangeProvider(_ memberAccessor: MemberAccessor) {
        if let id = extractValueRangeProviderId(memberAccessor) {
            fromSolutionValueRangeProviderMap[id] = memberAccessor
        } else {
            anonymousFromSolutionValueRangeProviderSet.insert(memberAccessor)
        }
    }

    public func isFromSolutionValueRangeProvider(_ memberAccessor: MemberAccessor) -> Bool {
        return fromSolutionValueRangeProviderMap.contains(where: { $0.value === memberAccessor })
            || anonymousFromSolutionValueRangeProviderSet.contains(memberAccessor)
    }

    public func hasFromSolutionValueRangeProvider(_ id: String) -> Bool {
        return fromSolutionValueRangeProviderMap.containsKey(id)
    }

    public func getFromSolutionValueRangeProvider(_ id: String) -> MemberAccessor? {
        return fromSolutionValueRangeProviderMap[id]
    }

    public func getAnonymousFromSolutionValueRangeProviderSet() -> Set<HashWrappedMemberAccessor> {
        return anonymousFromSolutionValueRangeProviderSet
    }

    public func addFromEntityValueRangeProvider(_ memberAccessor: MemberAccessor) {
        if let id = extractValueRangeProviderId(memberAccessor) {
            fromEntityValueRangeProviderMap[id] = memberAccessor
        } else {
            anonymousFromEntityValueRangeProviderSet.insert(memberAccessor)
        }
    }

    public func isFromEntityValueRangeProvider(_ memberAccessor: MemberAccessor) -> Bool {
        return fromEntityValueRangeProviderMap.contains(where: { $0.value === memberAccessor })
            || anonymousFromEntityValueRangeProviderSet.contains(memberAccessor)
    }

    public func hasFromEntityValueRangeProvider(_ id: String) -> Bool {
        return fromEntityValueRangeProviderMap.containsKey(id)
    }

    public func getAnonymousFromEntityValueRangeProviderSet() -> Set<HashWrappedMemberAccessor> {
        return anonymousFromEntityValueRangeProviderSet
    }

    public func setMemberAccessorFactory(_ memberAccessorFactory: MemberAccessorFactory) {
        self.memberAccessorFactory = memberAccessorFactory
    }

    public func getFromEntityValueRangeProvider(id: String) -> MemberAccessor? {
        return fromEntityValueRangeProviderMap[id]
    }

    private func extractValueRangeProviderId(_ memberAccessor: MemberAccessor) -> String? {
        let annotation = memberAccessor.getAnnotation(ValueRangeProviderAnnotation.self)
        let id = annotation.id
        // WIP: Check whether it is necessary that id can be nil in ValueRangeProviderAnnotation
        guard /*let id = id,*/ !id.isEmpty else {
            return nil
        }
        validateUniqueValueRangeProviderId(id, memberAccessor: memberAccessor)
        return id
    }

    private func validateUniqueValueRangeProviderId(_ id: String,memberAccessor: MemberAccessor) {
        let solutionDuplicate = fromSolutionValueRangeProviderMap[id]
        if solutionDuplicate != nil {
            return illegalState(
                "2 members (" + String(describing: solutionDuplicate) + ", "
                    + String(describing: memberAccessor) + ") with a @"
                    + String(describing: ValueRangeProviderAnnotation.self)
                    + " annotation must not have the same id (" + id + ")."
            )
        }
        let entityDuplicate = fromEntityValueRangeProviderMap[id]
        if entityDuplicate != nil {
            return illegalState(
                "2 members (" + String(describing: entityDuplicate) + ", "
                    + String(describing: memberAccessor) + ") with a @"
                    + String(describing: ValueRangeProviderAnnotation.self)
                    + " annotation must not have the same id (" + id + ")."
            )
        }
    }

    public func getValueRangeProviderIds() -> [String] {
        return Array(fromSolutionValueRangeProviderMap.keys) + fromEntityValueRangeProviderMap.keys
    }

}
