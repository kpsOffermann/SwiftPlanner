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

/*
 WIP: Implement actual features. (This is currently a mockup to collect the needed features.)
 
 Very likely this will be replaced by usage of swift-Atomics package:
 dependencies:
 .package(url: "https://github.com/apple/swift-atomics.git", .upToNextMajor(from: "1.0.0")),
 targte/dependencies: .product(name: "Atomics", package: "swift-atomics")
 */

public class AtomicReference<T> {
    
    private var value: T
    
    init(_ value: T) {
        self.value = value
    }
    
    func set(_ value: T) {
        self.value = value
    }
    
    func get() -> T {
        return value
    }
    
}
