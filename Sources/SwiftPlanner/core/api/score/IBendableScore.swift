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

public typealias IBendableScore = UBendableScore & Score

/**
 * Bendable score is a {@link Score} whose {@link #hardLevelsSize()} and {@link #softLevelsSize()}
 * are only known at runtime.
 *
 * @apiNote Interfaces in OptaPlanner are usually not prefixed with "I".
 *          However, the conflict in name with its implementation ({@link BendableScore}) made this necessary.
 *          All the other options were considered worse, some even harmful.
 *          This is a minor issue, as users will access the implementation and not the interface anyway.
 * @implSpec As defined by {@link Score}.
 * @param <Score_> the actual score type to allow addition, subtraction and other arithmetic
 */
public protocol UBendableScore {

    /**
     * The sum of this and {@link #softLevelsSize()} equals {@link #levelsSize()}.
     *
     * @return {@code >= 0} and {@code <} {@link #levelsSize()}
     */
    func hardLevelsSize() -> Int

    /**
     * The sum of {@link #hardLevelsSize()} and this equals {@link #levelsSize()}.
     *
     * @return {@code >= 0} and {@code <} {@link #levelsSize()}
     */
    func softLevelsSize() -> Int

    /**
     * @return {@link #hardLevelsSize()} + {@link #softLevelsSize()}
     */
    func levelsSize() -> Int

}

// default implementations
extension UBendableScore {
    
    public func levelsSize() -> Int {
        return hardLevelsSize() + softLevelsSize();
    }
    
}
