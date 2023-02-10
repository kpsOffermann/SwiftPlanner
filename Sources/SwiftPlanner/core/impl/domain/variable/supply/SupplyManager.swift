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
 * Provides a {@link Supply} for subsystems that submit a {@link Demand}.
 */
public protocol SupplyManager {

    /**
     * Returns the {@link Supply} for a {@link Demand}, preferably an existing one.
     * If the {@link Supply} doesn't exist yet (as part of the domain model or externalized), it creates and attaches it.
     * If two {@link Demand} instances {@link Object#equals(Object) are equal},
     * they will result in the same {@link Supply} instance.
     * Each supply instance keeps a counter of how many times it was requested,
     * which can be decremented by {@link #cancel(Demand)}.
     *
     * @param demand never null
     * @param <Supply_> Subclass of {@link Supply}
     * @return never null
     */
    func demand<Supply_ : Supply>(demand: some Demand<Supply_>) -> Supply_

    /**
     * Cancel an active {@link #demand(Demand)}.
     * Once the number of active demands reaches zero, the {@link Supply} in question is removed.
     * <p>
     * This operation is optional.
     * Supplies with active demands will live for as long as the {@link SupplyManager} lives,
     * and get garbage-collected together with it.
     *
     * @param demand never null
     * @param <Supply_>
     * @return true if the counter was decremented, false if there is no such supply
     */
     func cancel<Supply_ : Supply>(demand: some Demand<Supply_>) -> Bool

    /**
     * @param demand
     * @return 0 when there is no active {@link Supply} for the given {@link Demand}, more when there is one.
     * @param <Supply_>
     */
    func getActiveCount<Supply_ : Supply>(demand: some Demand<Supply_>) -> Int64

}
