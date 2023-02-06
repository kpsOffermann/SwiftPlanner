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

/// Precedence group for transformations on methods.
precedencegroup MethodTransformerPrecedence {
    associativity: left
    higherThan: BitwiseShiftPrecedence
}

/// The optional chaining operator for closures.
postfix operator .?

/// The optional chaining operator for closures.
infix operator .? : MethodTransformerPrecedence

/**
 Expands a one-parameter function/closure into an optional chaining function, ie it then accepts
 `nil` as parameter, and passes it on.
  
 Example:
 `Minute.from.?` is a function that will return
 - `nil`, if `$0` is `nil`
 - `Minute.from($0)`, otherwise

 - Remark: If the argument for the function is directly available (eg `let time: JustTime? = ...`),
           the infix operator should be used: eg `Minute.from.?(time)`.

 - Parameter closure: the function/closure that gets expanded.
  
 - Returns: function that is expanded for optional chaining.
 */
postfix func .?<A, B>(closure: @escaping (A) -> B) -> (A?) -> B? {
    return { closure.?($0) }
}

/**
  Expands a one-parameter function/closure into an optional chaining function, ie it accepts `nil`
  as parameter, and passes it on.
   
  Example (with `let time: JustTime? = ...`):
  `Minute.from.?(time)` will return
  - `nil`, if `time` is `nil`
  - `Minute.from(time)`, otherwise

  - Parameter closure: the function/closure that gets expanded.
  - Parameter value: the parameter for the closure.
   
  - Returns: `nil`, if `value` is `nil`, otherwise the result of passing `value` to the closure.
  */
 func .?<A, B>(closure: @escaping (A) -> B, value: A?) -> B? {
     return value ??! closure ..! nil
 }
