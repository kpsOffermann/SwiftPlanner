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

// WIP: Logger

public typealias AbstractScoreDirectorFactory<Solution_ : PlanningSolution, Score_ : Score>
    = AbstractScoreDirectorFactoryClass<Solution_, Score_> & InnerScoreDirectorFactory

/**
 * Abstract superclass for {@link ScoreDirectorFactory}.
 *
 * @param <Solution_> the solution type, the class with the {@link PlanningSolution} annotation
 * @param <Score_> the score type to go with the solution
 * @see ScoreDirectorFactory
 */
public /*abstract*/ class AbstractScoreDirectorFactoryClass<
        Solution_ : PlanningSolution,
        Score_ : Score
> : AbstractScoreDirectorFactoryDependent {

    /* WIP: Logger
    protected final transient Logger logger = LoggerFactory.getLogger(getClass());
     */

    let solutionDescriptor: SolutionDescriptor<Solution_, Score_>

    var initializingScoreTrend: InitializingScoreTrend?

    public internal(set)
        var assertionScoreDirectorFactory: (any InnerScoreDirectorFactory<Solution_, Score_>)?

    public var assertClonedSolution = false

    public init(_ solutionDescriptor: SolutionDescriptor<Solution_, Score_>) {
        self.solutionDescriptor = solutionDescriptor
    }

    public func getSolutionDescriptor() -> SolutionDescriptor<Solution_, Score_> {
        return solutionDescriptor
    }

    func getScoreDefinition() -> (any ScoreDefinition<Score_>)? {
        return solutionDescriptor.getScoreDefinition()
    }

    public func getInitializingScoreTrend() -> InitializingScoreTrend {
        return initializingScoreTrend
            ?? illegalState("initializing score trend is uninitionalized!")
    }
    
    public func setInitializingScoreTrend(_ initializingScoreTrend: InitializingScoreTrend) {
        self.initializingScoreTrend = initializingScoreTrend
    }

    public func setAssertionScoreDirectorFactory(
            _ assertionScoreDirectorFactory: any InnerScoreDirectorFactory<Solution_, Score_>
    ) {
        self.assertionScoreDirectorFactory = assertionScoreDirectorFactory
    }

}

// Helper type to add methods to not-abstract subtypes.
public protocol AbstractScoreDirectorFactoryDependent {}

public extension AbstractScoreDirectorFactoryDependent where Self : InnerScoreDirectorFactory {
    
    // ************************************************************************
    // Complex methods
    // ************************************************************************
    
    func buildScoreDirector() -> any InnerScoreDirector<Solution_, Score_> {
        return buildScoreDirector(lookUpEnabled: true, constraintMatchEnabledPreference: true)
    }
    
    func assertScoreFromScratch(solution: Solution_) {
        // Get the score before uncorruptedScoreDirector.calculateScore() modifies it
        guard let score = getSolutionDescriptor().getScore(solution) else {
            return illegalState("Solution descriptor's score is uninitionalized!")
        }
        // WIP: AutoCloseable, tryWithResources
        let uncorruptedScoreDirector = buildScoreDirector(
            lookUpEnabled: false,
            constraintMatchEnabledPreference: true
        )
        uncorruptedScoreDirector.setWorkingSolution(solution)
        let uncorruptedScore = uncorruptedScoreDirector.calculateScore()
        if score != uncorruptedScore {
            illegalState(
                "Score corruption (" + score.subtract(uncorruptedScore).toShortString()
                    + "): the solution's score (\(score)) is not the uncorruptedScore ("
                    + "\(uncorruptedScore.description)."
            )
        }
    }
    
}
