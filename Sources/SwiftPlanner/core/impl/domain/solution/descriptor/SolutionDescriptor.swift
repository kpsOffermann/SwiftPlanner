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

// WIP: currently contains only methods that are used somewhere else
/* WIP: requires annotations for
        processAnnotations, afterAnnotationsProcessed
 */
/* WIP: requires ReflectionFieldMemberAccessor for
        extractMemberCollectionOrArray
 */
// WIP: reimplement extractMemberCollectionOrArray

public class SolutionDescriptor<Solution_> {
    
    // WIP: type argument; WIP: see for alternative of static (in generic class)
    private let NULL_ENTITY_DESCRIPTOR = EntityDescriptor<Solution_>(nil, SolutionDescriptor.self)
    
    public static func buildSolutionDescriptor(
            _ solutionClass: Solution_.Type,
            entityClasses: Any.Type...
    ) -> SolutionDescriptor<Solution_> {
        return buildSolutionDescriptor(solutionClass, entityClassList: entityClasses)
    }
    
    public static func buildSolutionDescriptor(
            _ solutionClass: Solution_.Type,
            entityClassList: [Any.Type]
    ) -> SolutionDescriptor<Solution_> {
        return buildSolutionDescriptor(
            domainAccessType: .REFLECTION,
            solutionClass: solutionClass,
            memberAccessorMap: nil,
            solutionClonerMap: nil,
            entityClassList: entityClassList
        )
    }
    
    public static func buildSolutionDescriptor(
            domainAccessType: DomainAccessType,
            solutionClass: Solution_.Type,
            memberAccessorMap: [String:MemberAccessor]?,
            solutionClonerMap: [String:any SolutionCloner]?,
            entityClassList: [Any.Type]
    ) -> SolutionDescriptor<Solution_> {
        let solutionDescriptor = SolutionDescriptor<Solution_>(
            solutionClass: solutionClass,
            memberAccessorMap: memberAccessorMap
        )
        let descriptorPolicy = DescriptorPolicy()
        descriptorPolicy.domainAccessType = domainAccessType
        descriptorPolicy.generatedSolutionClonerMap = solutionClonerMap ?? .init()
        descriptorPolicy.setMemberAccessorFactory(solutionDescriptor.memberAccessorFactory)

        solutionDescriptor.processAnnotations(
            descriptorPolicy: descriptorPolicy,
            entityClassList: entityClassList
        )
        for entityClass in sortedEntityClassList(entityClassList) {
            let entityDescriptor = EntityDescriptor<Solution_>(solutionDescriptor, entityClass)
            solutionDescriptor.addEntityDescriptor(entityDescriptor)
            entityDescriptor.processAnnotations(descriptorPolicy)
        }
        solutionDescriptor.afterAnnotationsProcessed(descriptorPolicy)
        return solutionDescriptor
    }
    
    private static func sortedEntityClassList(_ entityClassList: [Any.Type]) -> [Any.Type] {
        var sortedEntityClassList = [Any.Type]()
        for entityClass in entityClassList {
            var added = false
            for (index, sortedEntityClass) in sortedEntityClassList.enumerated() {
                if MetaTypes.isAssignable(entityClass, from: sortedEntityClass) {
                    sortedEntityClassList.insert(entityClass, at: index)
                    added = true
                    break
                }
            }
            if !added {
                sortedEntityClassList.append(entityClass)
            }
        }
        return sortedEntityClassList
    }
    
    // ************************************************************************
    // Non-static members
    // ************************************************************************
    
    private let solutionClass: Solution_.Type
    private let memberAccessorFactory: MemberAccessorFactory
    
    private let entityMemberAccessorMap = [String:MemberAccessor]()
    private let entityCollectionMemberAccessorMap = [String:MemberAccessor]()
    private var scoreDescriptor: ScoreDescriptor?
    
    private let entityDescriptorMap = TypeDictionary<EntityDescriptor<Solution_>>()
    private var reversedEntityClassList = [Any.Type]()
    // WIP: Check concurrence.
    private let lowestEntityDescriptorMap = TypeDictionary<EntityDescriptor<Solution_>>()
    
    // ************************************************************************
    // Constructors and simple getters/setters
    // ************************************************************************
    
    private init(solutionClass: Solution_.Type, memberAccessorMap: [String:MemberAccessor]?) {
        self.solutionClass = solutionClass
        /* WIP: Logger
        if (solutionClass.getPackage() == null) {
            LOGGER.warn("The solutionClass ({}) should be in a proper java package.", solutionClass);
        }
         */
        self.memberAccessorFactory = MemberAccessorFactory(memberAccessorMap: memberAccessorMap)
    }
    
    public func addEntityDescriptor(_ entityDescriptor: EntityDescriptor<Solution_>) {
        let entityClass = entityDescriptor.entityClass
        for otherEntityClass in entityDescriptorMap.keys {
            if MetaTypes.isAssignable(entityClass, from: otherEntityClass) {
                return illegalArgument(
                    "An earlier entityClass (" + String(describing: otherEntityClass) +
                        ") should not be a subclass of a later entityClass ("
                        + String(describing: entityClass)
                        + "). Switch their declaration so superclasses are defined earlier."
                )
            }
        }
        entityDescriptorMap[entityClass] = entityDescriptor
        reversedEntityClassList.insert(entityClass, at: 0)
        lowestEntityDescriptorMap[entityClass] = entityDescriptor
    }
    
    public func processAnnotations(descriptorPolicy: DescriptorPolicy, entityClassList: [Any.Type]) {
        // WIP: Implement
    }
    
    private func afterAnnotationsProcessed(_ descriptorPolicy: DescriptorPolicy) {
        // WIP: Implement
    }
    
    /**
     * @param solution never null
     * @return {@code >= 0}
     */
    @available(macOS 13.0.0, *)
    public func getEntityCount(_ solution: Solution_) -> Int {
        var result: Int = 0
        visitAllEntities(solution, { _ in result += 1 }, collectionVisitor: { result += $0.count })
        return result
    }
    
    @available(macOS 13.0.0, *)
    public func visitAllEntities(solution: Solution_ , visitor: (Any) -> Void) {
        visitAllEntities(solution, visitor, collectionVisitor: { $0.forEach(visitor) })
    }
    
    @available(macOS 13.0.0, *)
    private func visitAllEntities(
            _ solution: Solution_,
            _ visitor: (Any) -> Void,
            collectionVisitor : ([Any]) -> Void
    ) {
        for entityMemberAccessor in entityMemberAccessorMap.values {
            visitor.?(extractMemberObject(entityMemberAccessor, solution))
        }
        for entityCollectionMemberAccessor in entityCollectionMemberAccessorMap.values {
            let entityCollection = extractMemberCollectionOrArray(
                entityCollectionMemberAccessor,
                solution,
                isFact: false
            )
            collectionVisitor(entityCollection)
        }
    }
    
    /**
     * @param scoreDirector never null
     * @return {@code >= 0}
     */
    @available(macOS 13.0.0, *)
    public func hasMovableEntities(_ scoreDirector: any ScoreDirector<Solution_>) -> Bool {
        return extractAllEntitiesStream(scoreDirector.getWorkingSolution())
            .contains(where: { entity in
                findEntityDescriptorOrFail(type(of: entity))
                    .isMovable(scoreDirector: scoreDirector, entity: entity)
            })
    }
    
    /**
      * @param solution never null
      * @return {@code >= 0}
      */
    public func getValueCount(_ solution: Solution_) -> Int {
        // let valueCount = 0
        // TODO FIXME for ValueRatioTabuSizeStrategy (or reuse maximumValueCount() for that variable descriptor?)
        return unsupportedOperation(
            "getValueCount is not yet supported - this blocks ValueRatioTabuSizeStrategy"
        )
        // return valueCount;
    }
    
    public func findEntityDescriptorOrFail(_ entitySubclass: Any.Type) -> EntityDescriptor<Solution_> {
        return findEntityDescriptor(entitySubclass)
            ?? illegalArgument(""
            /* WIP: Update error message
                "A planning entity is an instance of a class (" + entitySubclass
                    + ") that is not configured as a planning entity class (" + getEntityClassSet() + ").\n" +
                    "If that class (" + entitySubclass.getSimpleName()
                    + ") (or superclass thereof) is not a @" + PlanningEntity.class.getSimpleName()
                    + " annotated class, maybe your @" + PlanningSolution.class.getSimpleName()
                    + " annotated class has an incorrect @" + PlanningEntityCollectionProperty.class.getSimpleName()
                    + " or @" + PlanningEntityProperty.class.getSimpleName() + " annotated member.\n"
                    + "Otherwise, if you're not using the Quarkus extension or Spring Boot starter,"
                    + " maybe that entity class (" + entitySubclass.getSimpleName()
                    + ") is missing from your solver configuration."
             */
                )
    }
    
    public func findEntityDescriptor(_ entitySubclass: Any.Type) -> EntityDescriptor<Solution_>? {
        /*
         * A slightly optimized variant of map.computeIfAbsent(...).
         * computeIfAbsent(...) would require the creation of a capturing lambda every time this method is called,
         * which is created, executed once, and immediately thrown away.
         * This is a micro-optimization, but it is valuable on the hot path.
         */
        let cachedEntityDescriptor = lowestEntityDescriptorMap[entitySubclass]
        if cachedEntityDescriptor === NULL_ENTITY_DESCRIPTOR { // Cache hit, no descriptor found.
            return nil
        } else if cachedEntityDescriptor != nil { // Cache hit, descriptor found.
            return cachedEntityDescriptor
        }
        // Cache miss, look for the descriptor.
        let newEntityDescriptor = innerFindEntityDescriptor(entitySubclass)
        if (newEntityDescriptor == nil) {
            // Dummy entity descriptor value, as ConcurrentMap does not allow null values.
            lowestEntityDescriptorMap[entitySubclass] = NULL_ENTITY_DESCRIPTOR
            return nil
        } else {
            lowestEntityDescriptorMap[entitySubclass] = newEntityDescriptor
            return newEntityDescriptor
        }
    }
    
    private func innerFindEntityDescriptor(_ entitySubclass: Any.Type) -> EntityDescriptor<Solution_>? {
        // Reverse order to find the nearest ancestor
        for entityClass in reversedEntityClassList {
            if MetaTypes.isAssignable(entityClass, from: entitySubclass) {
                return entityDescriptorMap[entityClass]
            }
        }
        return nil
    }
    
    @available(macOS 13.0.0, *)
    private func extractAllEntitiesStream(_ solution: Solution_) -> [Any] {
        var result = [Any]()
        for memberAccessor in entityMemberAccessorMap.values {
            let entity = extractMemberObject(memberAccessor, solution)
            if let element = entity {
                result.append(element)
            }
        }
        for memberAccessor in entityCollectionMemberAccessorMap.values {
            let entityCollection = extractMemberCollectionOrArray(
                memberAccessor,
                solution,
                isFact: false
            )
            result.append(contentsOf: entityCollection)
        }
        return result
    }
    
    private func extractMemberObject(
            _ memberAccessor: MemberAccessor,
            _ solution: Solution_
    ) -> Any? {
        return memberAccessor.executeGetter(solution)
    }
    
    @available(macOS 13.0.0, *)
    private func extractMemberCollectionOrArray(
            _ memberAccessor: MemberAccessor,
            _ solution: Solution_,
            isFact: Bool
    ) -> [Any] {
        // WIP: Rework implementation of this method
        if let object = memberAccessor.executeGetter(solution) {
            let mirror = Mirror(reflecting: object)
            if mirror.displayStyle == .collection {
                return mirror.children.map({ $0 })
            }
        }
        /*
        var result: [Any]?
        if Types.isArray(memberAccessor.getType()) {
            let arrayObject = memberAccessor.executeGetter(solution)
            result = ReflectionHelper.transformArrayToList(arrayObject)
        } else {
            //let collection = memberAccessor.executeGetter(solution) as? any Collection<Any>
            //result = Array.init.?(memberAccessor.executeGetter(solution) as? any Collection<Any>)
            let collection = memberAccessor.executeGetter(solution) as? (any Collection)
            result = invokeOrNil([Any].init, collection)
        }
        return result ??
         */
        return illegalArgument(
                "The solutionClass (" + String(describing: solutionClass) + ")'s "
                + (isFact ? "factCollectionProperty" : "entityCollectionProperty") + " ("
                + String(describing: memberAccessor) + ") should never return nil.\n"
            /* WIP: ReflectionFieldMemberAccessor
                + (memberAccessor is ReflectionFieldMemberAccessor
                   ? ""
                   : "Maybe the getter/method always returns null instead of the actual data.\n")
             */
                + "Maybe that property (" + memberAccessor.getName()
                + ") was set with nil instead of an empty collection/array when the class ("
                + String(describing: solutionClass) + ") instance was created."
            )
    }
    
    /**
     * @param solution never null
     * @return sometimes null, if the {@link Score} hasn't been calculated yet
     */
    public func getScore(_ solution: Solution_) -> (any Score)? {
        guard let scoreDescriptor = scoreDescriptor else {
            return illegalState("scoreDescriptor is uninitialized!")
        }
        return scoreDescriptor.getScore(solution)
    }
    
    /**
     * Called when the {@link Score} has been calculated or predicted.
     *
     * @param solution never null
     * @param score sometimes null, in rare occasions to indicate that the old {@link Score} is stale,
     *        but no new ones has been calculated
     */
    public func setScore(solution: Solution_, score: any Score) {
        guard let scoreDescriptor = scoreDescriptor else {
            return illegalState("scoreDescriptor is uninitialized!")
        }
        scoreDescriptor.setScore(solution: solution, score: score)
    }
    
}
