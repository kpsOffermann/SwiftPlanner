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
 Utility class providing mathematical functions.
 */
enum Math {
    
    /**
     Returns the mathematical modulo of the given dividend and divisor, i.e. a number in the range
     0..<divisor.
     
     - Parameter dividend: the dividend.
     - Parameter divisor: the divisor.
     
     - Return: the mouldo value of dividend by divisor.
     */
    static func modulo(of dividend: Int, by divisor: Int) -> Int {
        return ((dividend % divisor) + divisor) % divisor
    }
    
}
