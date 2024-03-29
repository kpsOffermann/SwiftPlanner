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
@testable import SwiftPlanner

class ReflectionHelperTest : XCTestCase {
    
    func test_transformArrayToList() {
        let array: Any = [7, 9, 23]
        let expected = [7, 9, 23]
        let preActual = ReflectionHelper.transformArrayToList(array)
        guard let actual = preActual as? [Int] else {
            XCTFail("Method returned nil instead of \(expected)")
            fatalError()
        }
        XCTAssertEqual(actual, expected)
    }
    
}
