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

public enum PlanningVariableGraphType {
    
    /**
     * This is the default.
     */
    case NONE
    
    /**
     * Changes to this variable need to trigger chain correction.
     * <p>
     * In some use cases, such as Vehicle Routing, planning entities are chained.
     * A chained variable recursively points to a problem fact, which is called the anchor.
     * So either it points directly to the anchor (that problem fact)
     * or it points to another planning entity which recursively points to the anchor.
     * Chains always have exactly 1 anchor, thus they never loop and the tail is always open.
     * Chains never split into a tree: an anchor or planning entity has at most 1 trailing planning entity.
     * <p>
     * When a chained planning entity changes position, then chain correction must happen:
     * <ul>
     * <li>divert the chain link at the new position to go through the modified planning entity</li>
     * <li>close the missing chain link at the old position</li>
     * </ul>
     * For example: Given {@code A <- B <- C <- D <- X <- Y}, when B moves between X and Y, pointing to X,
     * then Y is also changed to point to B
     * and C is also changed to point to A,
     * giving the result {@code A <- C <- D <- X <- B <- Y}.
     * <p>
     * {@link PlanningVariable#nullable()} true is not compatible with this.
     */
    case CHAINED

    // TODO TREE (DIRECTED_GRAPH)

}
