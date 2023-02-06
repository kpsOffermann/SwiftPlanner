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
 Stand-in for an abstract method.
 
 Call this method as body for every method with a return value that normally would be defined as
 abstract method.
 
 - Parameter type: type of the object where the override is missing.
 - Parameter file: the file in which failure occurred. Defaults to the file name of the test
                   case in which this function was called.
 - Parameter line: the line number on which failure occurred. Defaults to the line number on
                   which this function was called.
                   
 - Returns: nothing. The method will always throw before reaching the return statement.
 */
func isAbstractMethod<T>(
        _ type: Any.Type,
        file: StaticString = #file,
        line: UInt = #line,
        function: String = #function
) -> T {
    abstractMethodFailure(type, file: file, line: line, function: function)
    fatalError("This line is unreachable because of the error in the abstractMethodBody!")
}

// Documentation: see above.
func isAbstractMethod(
        _ type: Any.Type,
        file: StaticString = #file,
        line: UInt = #line,
        function: String = #function
) {
    abstractMethodFailure(type, file: file, line: line, function: function)
}

/// Always throwing body for abstract methods.
private func abstractMethodFailure(
        _ type: Any.Type,
        file: StaticString = #file,
        line: UInt = #line,
        function: String = #function
) {
    preconditionFailure(
        "Abstract method \(function) has to be overridden in subclass"
            + " \(String(describing: type)): \(file.shortFileName), l. \(line)"
    )
}

/// This method can be called as runtime check in init of abstract classes.
func assertOverridden<T : Any>(_ abstractType: T.Type, _ instance: T) {
    assert(
        type(of: instance) != abstractType,
        "Creating instances of abstract class \(String(describing: abstractType)) is forbidden!"
    )
}
