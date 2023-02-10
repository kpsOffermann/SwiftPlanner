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

/**
 * A subsystem submits a demand for a {@link Supply}.
 * Implementations must overwrite {@link Object#equals(Object)} and {@link Object#hashCode()}.
 *
 * @param <Supply_> Subclass of {@link Supply}
 * @see Supply
 * @see SupplyManager
 */
public protocol Demand<Supply_> {
    
    associatedtype Supply_ : Supply

    /**
     * Only called if the domain model doesn't already support the demand (through a shadow variable usually).
     * Equal demands share the same {@link Supply}.
     *
     * @param supplyManager never null
     * @return never null
     */
    func createExternalizedSupply(supplyManager: SupplyManager) -> Supply_

}
