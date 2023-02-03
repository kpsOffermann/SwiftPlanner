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

 NOTICE: This file is based on the optaPlanner engine by kiegroup 
         (https://github.com/kiegroup/optaplanner), which is licensed 
         under the Apache License, Version 2.0, too. Furthermore, this
         file has been modified including (but not necessarily
         limited to) translating the original file to Swift.
 */

/// The left part of the optional-based ite-operator.
infix operator ??! : TernaryPrecedence

/// The right part of the optional-based ite-operator.
infix operator ..! : TernaryPrecedence

// MARK: ite operator for optionals.
/**
 Extends Optional with ite operator for optionals.

 The ite operator for optionals is a ternary operator that returns either a value computed from
 the not-nil value or a default value if the given value is nil.

 Example:
 Let number be of type Int?

 The expression `number ??! { 7 * $0 } ..! 1`

 will return:
 * 1, if the number is nil
 * 7 * number, if number is not nil.
 */

/**
 The left part of the ite operator for optionals.

 - Remark: See description below the mark "ite operator for optionals".

 - Parameter value: the optional value based on which the return is computed.
 - Parameter blocks: the blocks to compute the result. If value is not nil, it is given to
                     `blocks.then` to compute the result, otherwise `blocks.else` is the result.

 - Returns: `blocks.else`, if `value` is nil, otherwise `blocks.then(value)`
 */
func ??!<T, U>(value: T?, blocks: (then: (T) -> U, else: U)) -> U {
    if let value = value {
        return blocks.then(value)
    }
    return blocks.else
}

/**
 The right part of the ite operator for optionals. It just pairs two parameters into a tuple.

 - Remark: See description below the mark "ite operator for optionals".

 - Parameter thenBlock: the first component of the result.
 - Parameter elseBlock: the second component of the result.

 - Returns: a tuple with the given values as components.
 */
func ..!<T, U>(thenBlock: @escaping (T) -> U, elseBlock: U) -> (then: (T) -> U, else: U) {
    (thenBlock, elseBlock)
}
