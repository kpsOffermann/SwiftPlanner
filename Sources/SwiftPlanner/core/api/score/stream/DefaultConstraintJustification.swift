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

// WIP: Implement last part of getClassAndIdPlanningComparator method

import Foundation

public typealias Fact = CustomStringConvertible

/**
 * Default implementation of {@link ConstraintJustification}, returned by {@link ConstraintMatch#getJustification()}
 * unless the user defined a custom justification mapping.
 */
public final class DefaultConstraintJustification : ConstraintJustification, SPComparable, JavaStringConvertible {
    
    public static func of(impact: some Score, facts: Fact...) -> DefaultConstraintJustification {
        return DefaultConstraintJustification(impact: impact, facts: facts)
    }

    public static func of(_ impact: some Score, facts: [Fact]) -> DefaultConstraintJustification {
        return DefaultConstraintJustification(impact: impact, facts: facts)
    }

    private let impact: any Score
    private let facts: [Fact]
    private var classAndIdPlanningComparator: SPComparator<Any>? = nil

    private init(impact: some Score, facts: [Fact]) {
        self.impact = impact
        self.facts = facts
    }

    public func getImpact() -> any Score {
        return impact
    }

    public func getFacts() -> [Fact] {
        return facts
    }

    public func toString() -> String {
        return facts.description
    }
    
    public static func ==(lhs: DefaultConstraintJustification, rhs: DefaultConstraintJustification) -> Bool {
        return Equals.check(lhs.impact, rhs.impact, orElse: { false })
            && lhs.facts.count == rhs.facts.count
            && zip(lhs.facts, rhs.facts).allSatisfy({ Equals.check($0, $1, orElse: { false }) })
    }
    
    public func compare(to other: DefaultConstraintJustification) -> ComparisonResult {
        let scoreComparison = impact.compare(
            to: other.impact,
            orElse: {
                // Don't fail on two different score types.
                let impactClassName = String(describing: type(of: impact))
                let otherImpactClassName = String(describing: type(of: other.impact))
                return String.compare(impactClassName, otherImpactClassName)
            }
        )
        if scoreComparison != .orderedSame {
            return scoreComparison
        }
        let justificationList = getFacts()
        let otherJustificationList = other.getFacts()
        if justificationList.count != otherJustificationList.count {
            return Int.compare(justificationList.count, otherJustificationList.count)
        } else {
            let comparator = getClassAndIdPlanningComparator(other: other)
            for (left, right) in zip(justificationList, otherJustificationList) {
                let comparison = comparator(left, right)
                if comparison != .orderedSame {
                    return comparison
                }
            }
        }
        return ObjectIdentifier.compare(ObjectIdentifier(self), ObjectIdentifier(other))
    }

    private func getClassAndIdPlanningComparator(
            other: DefaultConstraintJustification
    ) -> SPComparator<Any> {
        /*
         * The comparator performs some expensive operations, which can be cached.
         * For optimal performance, this cache (MemberAccessFactory) needs to be shared between comparators.
         * In order to prevent the comparator from being shared in a static field creating a de-facto memory leak,
         * we cache the comparator inside this class, and we minimize the number of instances that will be created
         * by creating the comparator when none of the constraint matches already carry it,
         * and we store it in both.
         */
        return classAndIdPlanningComparator
            ?? other.classAndIdPlanningComparator
            ?? { lhs, rhs in
                Comparators.by({ $0 }, orElse: {
                    return missingFeature(
                        "Automatic comparator recognition for types "
                            + String(describing: type(of: lhs)) + " and "
                            + String(describing: type(of: rhs)) + " not yet implemented!"
                    )
                })(lhs, rhs)
            }
        /*
         * FIXME Using reflection will break Quarkus once we don't open up classes for reflection any more.
         * Use cases which need to operate safely within Quarkus should use SolutionDescriptor's MemberAccessorFactory.
         */
        
        /* WIP
        classAndIdPlanningComparator =
                new ClassAndPlanningIdComparator(new MemberAccessorFactory(), DomainAccessType.REFLECTION, false);
        other.classAndIdPlanningComparator = classAndIdPlanningComparator;
        return classAndIdPlanningComparator;
         */
    }

}
