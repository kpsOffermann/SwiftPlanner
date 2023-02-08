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

import XCTest
@testable import SwiftPlanner

/**
 * @see PlannerTestUtils
 */
public enum PlannerAssert {

    public static let DO_NOT_ASSERT_SIZE = Int64.min

    // ************************************************************************
    // Missing JUnit methods
    // ************************************************************************

    public static func assertObjectsAreEqual<C : Comparable & Hashable>(_ objects: C...) {
        for i in 0 ..< objects.count {
            for j in (i + 1) ..< objects.count {
                XCTAssertEqual(objects[j], objects[i])
                XCTAssertSameHash(objects[j], objects[i])
                XCTAssertEqualByComparing(objects[i], objects[j])
            }
        }
    }
    
    public static func assertObjectsAreEqual<H : Hashable>(_ objects: H...) {
        assertObjectsAreEqualWithoutComparing(objects)
    }

    public static func assertObjectsAreEqualWithoutComparing<H : Hashable>(_ objects: [H]) {
        for i in 0 ..< objects.count {
            for j in (i + 1) ..< objects.count {
                XCTAssertEqual(objects[j], objects[i])
                XCTAssertSameHash(objects[j], objects[i])
            }
        }
    }

    public static func assertObjectsAreNotEqual<C : Comparable>(_ objects: C...) {
        for i in 0 ..< objects.count {
            for j in (i + 1) ..< objects.count {
                XCTAssertNotEqual(objects[j], objects[i])
                XCTAssertNotEqualByComparing(objects[i], objects[j])
            }
        }
    }
    
    public static func assertObjectsAreNotEqual<E : Equatable>(_ objects: E...) {
        assertObjectsAreNotEqualWithoutComparing(objects)
    }
    
    public static func assertObjectsAreNotEqualWithoutComparing<E : Equatable>(_ objects: [E]) {
        for i in 0 ..< objects.count {
            for j in (i + 1) ..< objects.count {
                XCTAssertNotEqual(objects[j], objects[i])
            }
        }
    }
    
    public static func assertCompareToOrder<C : SPComparable>(_ objects: C...) {
        assertCompareToOrder(by: C.compare, objects)
    }

    public static func assertCompareToOrder<T>(by comparator: SPComparator<T>, _ objects: T...) {
        assertCompareToOrder(by: comparator, objects)
    }
    
    public static func assertCompareToOrder<T>(by comparator: SPComparator<T>, _ objects: [T]) {
        XCTAssertIsSorted(objects, by: comparator)
    }

}
