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
 * Marker interface for constraint justifications.
 * All classes used as constraint justifications must implement this interface.
 *
 * <p>
 * No two instances of such implementing class should be equal,
 * as it is possible for the same constraint to be justified twice by the same facts.
 * (Such as in the case of a non-distinct {@link ConstraintStream}.)
 *
 * <p>
 * Implementing classes may decide to implement {@link Comparable}
 * to preserve order of instances when displayed in user interfaces, logs etc.
 *
 * @see ConstraintMatch#getJustification()
 */
public protocol ConstraintJustification : AnyObject, CustomStringConvertible {

}
