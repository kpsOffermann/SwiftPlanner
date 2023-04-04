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

/**
 Informs the programmer that an illegal state has occured, e.g. a method is called before some
 preconditions for the call are met.
 
 - Parameter errorMessage: message to describe what source code is missing.
 
 - Returns: nothing. The method will always cause fatal error before reaching the return statement.
 */
func illegalState<T>(_ errorMessage: String) -> T {
    fatalError(errorMessage)
}

// Documentation: see above.
func illegalState(_ errorMessage: String) {
    let _: Any = missingFeature(errorMessage)
}
