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

// WIP: This is currently a mockup to collect the needed features, especially: add concurrency.

@available(macOS 10.15.0, *)
public class BlockingQueue<Element> {
    
    private var elements = [Element]()
    
    var isEmpty: Bool {
        return elements.isEmpty
    }
    
    func add(_ element: Element) -> Bool {
        elements.append(element)
        return true
    }
    
    func addAll<S : Sequence>(_ newElements: S) -> Bool where S.Element == Element {
        elements += newElements
        return true
    }
    
}
