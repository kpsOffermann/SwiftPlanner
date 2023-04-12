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

/* WIP: requires ConfigUtils for
        findMemberAccessor
 */

import Foundation

public final class ClassAndPlanningIdComparator : ComparatorSource {

    private let memberAccessorFactory: MemberAccessorFactory
    private let domainAccessType: DomainAccessType
    private let failFastIfNoPlanningId: Bool
    private let decisionCache = TypeDictionary<MemberAccessor>()

    public init(
            memberAccessorFactory: MemberAccessorFactory,
            domainAccessType: DomainAccessType,
            failFastIfNoPlanningId: Bool
    ) {
        self.memberAccessorFactory = memberAccessorFactory
        self.domainAccessType = domainAccessType
        self.failFastIfNoPlanningId = failFastIfNoPlanningId
    }

    public func compare(_ a: Fact, _ b: Fact) -> ComparisonResult {
        // WIP: Check whether nil values are needed
        /*
        if (a == nil) {
            return b == nil ? 0 : -1
        } else if (b == nil) {
            return 1
        }*/
        let aClass = type(of: a)
        let bClass = type(of: b)
        if aClass != bClass {
            return MetaTypes.name(aClass).compare(to: MetaTypes.name(bClass))
        }
        let aIdMemberAccessorOrNil = decisionCache.computeIfAbsent(aClass, orElse: findMemberAccessor)
        let bIdMemberAccessorOrNil = decisionCache.computeIfAbsent(bClass, orElse: findMemberAccessor)
        if failFastIfNoPlanningId {
            if aIdMemberAccessorOrNil == nil {
                return illegalArgument(failMessageNoPlanningIdFor(aClass))
            }
            if bIdMemberAccessorOrNil == nil {
                return illegalArgument(failMessageNoPlanningIdFor(bClass))
            }
        }
        guard let aIdMemberAccessor = aIdMemberAccessorOrNil else {
            if bIdMemberAccessorOrNil == nil {
                if let lhsC = a as? any Comparable {
                    // WIP: Check whether this illegal state case was intentional in the original
                    return lhsC.compare(to: b)
                        ?? illegalState("Facts \(a) and \(b) are not comparable")
                }
                // Keep original order.
                return .orderedSame
            }
            return .orderedAscending
        }
        guard let bIdMemberAccessor = bIdMemberAccessorOrNil else {
            return .orderedDescending
        }
        guard let aPlanningId = aIdMemberAccessor.executeGetter(a) else {
            return illegalArgument(failMessagePlannigIdIsNil(
                accessor: aIdMemberAccessorOrNil,
                clazz: aClass,
                fact: a
            ))
        }
        guard let bPlanningId = bIdMemberAccessor.executeGetter(b) else {
            return illegalArgument(failMessagePlannigIdIsNil(
                accessor: bIdMemberAccessorOrNil,
                clazz: bClass,
                fact: b
            ))
        }
        // If a and b are different classes, this method would have already returned.
        return (aPlanningId as? any Comparable)?.compare(to: bPlanningId)
            ?? illegalState("Facts \(aPlanningId) and \(bPlanningId) are not comparable")
    }
    
    private func failMessagePlannigIdIsNil(
            accessor: (any MemberAccessor)?,
            clazz: Any.Type,
            fact: Fact
    ) -> String {
        return "The planningId of the member (" // WIP: In the original, null was printed here.
            + String(describing: accessor) + ") of the class (" + String(describing: clazz)
            + ") on object (" + String(describing: fact) + ") must not be nil.\n"
            + "Maybe initialize the planningId of the original object before solving.."
    }
    
    private func failMessageNoPlanningIdFor(_ clazz: Any.Type) -> String {
        return "The class (" + String(describing: clazz)
            + ") does not have a property with @PlanningId annotation.\n"
            + "Maybe add the @PlanningId annotation."
    }

    private func findMemberAccessor(_ clazz: Any.Type) -> MemberAccessor? {
        return missingFeature("WIP")
        /* WIP: ConfigUtils
        return ConfigUtils.findPlanningIdMemberAccessor(clazz, memberAccessorFactory, domainAccessType);
         */
    }
    
}
