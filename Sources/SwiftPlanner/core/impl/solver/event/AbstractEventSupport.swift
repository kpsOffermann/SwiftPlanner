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

public /*abstract*/ class AbstractEventSupport<E : EventListener> {

    /**
     * {@link EntitySelector} instances may end up here.
     * Each instance added via {@link #addEventListener(EventListener)} must appear here,
     * regardless of whether it is equal to any other instance already present.
     * Likewise {@link #removeEventListener(EventListener)} must remove elements by identity, not equality.
     * <p>
     * This list-based implementation could be called an "identity set", similar to {@link IdentityHashMap}.
     * We can not use {@link IdentityHashMap}, because we require iteration in insertion order.
     */
    private var eventListenerList: [E] = []

    public func addEventListener(_ eventListener: E) {
        assert( // WIP: Check whether "opt-in" equatability is sufficient (or E has to be Equatable)
            !eventListenerList.contains(where: {
                Equals.check(eventListener, $0, orElse: { false })
            }),
            "Event listener (\(eventListener)) already found in list (\(eventListenerList))."
        )
        eventListenerList.append(eventListener)
    }

    public func removeEventListener(_ eventListener: E) where E : Equatable {
        assert(
            eventListenerList.removeFirst(where: {
                Equals.check(eventListener, $0, orElse: { false })
            }),
            "Event listener (\(eventListener)) not found in list (\(eventListenerList))."
        )
    }

    func getEventListeners() -> any Collection<E> {
        return eventListenerList
    }

}
