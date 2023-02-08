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

import XCTest
import SwiftPlanner

func XCTAssertEqualByComparing<C : Comparable>(
        _ actual: C,
        _ expected: C,
        file: StaticString = #file,
        line: UInt = #line
) {
    XCTAssertFalse(actual < expected, file: file, line: line)
    XCTAssertFalse(actual > expected, file: file, line: line)
}

/**
 Checks two arrays of equatable type for (order-insensitive) equality.
 In case of differences, informs the tester about the exact reason.
 
 - Parameter actual: the array which is checked.
 - Parameter expected: the expected value of the checked array.
 - Parameter file: the file in which failure occurred. Defaults to the file name of the test
                   case in which this function was called.
 - Parameter line: the line number on which failure occurred. Defaults to the line number on
                   which this function was called.
 */
func XCTAssertEqualIgnoringOrder<E : Equatable>(
        _ actual: [E],
        _ expected: [E],
        file: StaticString = #file,
        line: UInt = #line
) {
    var remaining = actual
    for result in expected {
        XCTAssertTrue(
            // Found element gets removed to handle duplicates correctly.
            remaining.removeFirstEqual(result),
            "\(result) is not found in the actual array.",
            file: file,
            line: line
        )
    }
    XCTAssertTrue(
        remaining.isEmpty,
        "additional elements in the actual array: \(remaining)",
        file: file,
        line: line
    )
    
}

// Documentation: see above.
func XCTAssertEqualIgnoringOrder<E : Equatable>(
        _ actual: [E],
        _ expected: E...,
        file: StaticString = #file,
        line: UInt = #line
) {
    XCTAssertEqualIgnoringOrder(actual, expected, file: file, line: line)
}

// Sorted ascending
func XCTAssertIsSorted<C : SPComparable>(
        _ array: [C],
        file: StaticString = #file,
        line: UInt = #line
) {
    XCTAssertIsSorted(array, by: C.compare, file: file, line: line)
}

// Sorted ascending
func XCTAssertIsSorted<E>(
        _ array: [E],
        by comparator: SPComparator<E>,
        file: StaticString = #file,
        line: UInt = #line
) {
    for i in 0 ..< array.count {
        for j in (i + 1) ..< array.count {
            let first = array[i]
            let second = array[j]
            XCTAssertNotEqual(comparator(first, second), .orderedDescending, file: file, line: line)
            XCTAssertNotEqual(comparator(second, first), .orderedAscending, file: file, line: line)
        }
    }
}

func XCTAssertNotEqualByComparing<C : Comparable>(
        _ actual: C,
        _ expected: C,
        file: StaticString = #file,
        line: UInt = #line
) {
    XCTAssertTrue(actual < expected || actual > expected, file: file, line: line)
}

func XCTAssertSameHash<H : Hashable>(
        _ actual: H,
        _ expected: H,
        file: StaticString = #file,
        line: UInt = #line
) {
    XCTAssertEqual(actual.hashValue, expected.hashValue, file: file, line: line)
}
