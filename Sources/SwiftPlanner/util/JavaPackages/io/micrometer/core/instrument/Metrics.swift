//
/*
 Copyright 2023 Micrometer-metrics
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

 NOTICE: This file is based on the API provided by io.micrometer.core.instrument.Metrics
         (https://github.com/micrometer-metrics/micrometer), which is licensed
         under the Apache License, Version 2.0, too. Furthermore, this
         file has been modified including (but not necessarily limited to) translating to Swift.
 */

// WIP: Implement actual features. (This is currently a mockup to collect the needed features.)

public enum Metrics {
    
    static func gauge<T>(name: String, tags: Tags, value: T, valueFunction: (T) -> Double) -> T {
        return value // WIP: see above
    }
    
}
