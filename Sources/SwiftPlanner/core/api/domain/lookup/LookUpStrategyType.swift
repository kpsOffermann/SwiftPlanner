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
 * Determines how {@link ScoreDirector#lookUpWorkingObject(Object)} maps
 * a {@link ProblemFactCollectionProperty problem fact} or a {@link PlanningEntity planning entity}
 * from an external copy to the internal one.
 */
public enum LookUpStrategyType {
    
    /**
     * Map by the same {@link PlanningId} field or method.
     * If there is no such field or method,
     * there is no mapping and {@link ScoreDirector#lookUpWorkingObject(Object)} must not be used.
     * If there is such a field or method, but it returns null, it fails fast.
     * <p>
     * This is the default.
     */
    case PLANNING_ID_OR_NONE
    
    /**
     * Map by the same {@link PlanningId} field or method.
     * If there is no such field or method, it fails fast.
     */
    case PLANNING_ID_OR_FAIL_FAST
    
    /**
     * Map by {@link Object#equals(Object) equals(Object)} and {@link Object#hashCode() hashCode()}.
     * If any of these two methods is not overridden by the working object's class or some of its superclasses,
     * {@link ScoreDirector#lookUpWorkingObject(Object)} must not be used because it cannot work correctly with
     * {@link Object}'s equals and hashCode implementations.
     */
    case EQUALITY
    
    /**
     * There is no mapping and {@link ScoreDirector#lookUpWorkingObject(Object)} must not be used.
     */
    case NONE

}
