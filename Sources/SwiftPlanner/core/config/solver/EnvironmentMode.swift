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

// WIP: @XmlEnum

/**
 * The environment mode also allows you to detect common bugs in your implementation.
 * <p>
 * Also, a {@link Solver} has a single {@link Random} instance.
 * Some optimization algorithms use the {@link Random} instance a lot more than others.
 * For example simulated annealing depends highly on random numbers,
 * while tabu search only depends on it to deal with score ties.
 * This environment mode influences the seed of that {@link Random} instance.
 */
// WIP: @XmlEnum
public enum EnvironmentMode {
    
    /**
     * This mode turns on all assertions
     * to fail-fast on a bug in a {@link Move} implementation, a constraint, the engine itself or something else
     * at a horrible performance cost.
     * <p>
     * This mode is reproducible (see {@link #REPRODUCIBLE} mode).
     * <p>
     * This mode is intrusive because it calls the {@link InnerScoreDirector#calculateScore()} more frequently
     * than a non assert mode.
     * <p>
     * This mode is horribly slow.
     */
    case FULL_ASSERT
    /**
     * This mode turns on several assertions (but not all of them)
     * to fail-fast on a bug in a {@link Move} implementation, a constraint, the engine itself or something else
     * at an overwhelming performance cost.
     * <p>
     * This mode is reproducible (see {@link #REPRODUCIBLE} mode).
     * <p>
     * This mode is non-intrusive, unlike {@link #FULL_ASSERT} and {@link #FAST_ASSERT}.
     * <p>
     * This mode is horribly slow.
     */
    case NON_INTRUSIVE_FULL_ASSERT
    /**
     * This mode turns on several assertions (but not all of them)
     * to fail-fast on a bug in a {@link Move} implementation, a constraint rule, the engine itself or something else
     * at a reasonable performance cost (in development at least).
     * <p>
     * This mode is reproducible (see {@link #REPRODUCIBLE} mode).
     * <p>
     * This mode is intrusive because it calls the {@link InnerScoreDirector#calculateScore()} more frequently
     * than a non assert mode.
     * <p>
     * This mode is slow.
     */
    case FAST_ASSERT
    /**
     * The reproducible mode is the default mode because it is recommended during development.
     * In this mode, 2 runs on the same computer will execute the same code in the same order.
     * They will also yield the same result, except if they use a time based termination
     * and they have a sufficiently large difference in allocated CPU time.
     * This allows you to benchmark new optimizations (such as a new {@link Move} implementation) fairly
     * and reproduce bugs in your code reliably.
     * <p>
     * Warning: some code can disrupt reproducibility regardless of this mode. See the reference manual for more info.
     * <p>
     * In practice, this mode uses the default random seed,
     * and it also disables certain concurrency optimizations (such as work stealing).
     */
    case REPRODUCIBLE
    /**
     * The non reproducible mode is equally fast or slightly faster than {@link #REPRODUCIBLE}.
     * <p>
     * The random seed is different on every run, which makes it more robust against an unlucky random seed.
     * An unlucky random seed gives a bad result on a certain data set with a certain solver configuration.
     * Note that in most use cases the impact of the random seed is relatively low on the result.
     * An occasional bad result is far more likely to be caused by another issue (such as a score trap).
     * <p>
     * In multithreaded scenarios, this mode allows the use of work stealing and other non deterministic speed tricks.
     */
    case NON_REPRODUCIBLE

    public func isAsserted() -> Bool {
        switch (self) {
            case .FULL_ASSERT, .NON_INTRUSIVE_FULL_ASSERT, .FAST_ASSERT:
                return true
            case .REPRODUCIBLE, .NON_REPRODUCIBLE:
                return false
        }
    }

    public func isNonIntrusiveFullAsserted() -> Bool{
        switch (self) {
            case .FULL_ASSERT, .NON_INTRUSIVE_FULL_ASSERT:
                return true
            case .FAST_ASSERT, .REPRODUCIBLE, .NON_REPRODUCIBLE:
                return false
        }
    }

    public func isIntrusiveFastAsserted() -> Bool {
        switch (self) {
            case .FULL_ASSERT, .FAST_ASSERT:
                return true
            case .NON_INTRUSIVE_FULL_ASSERT, .REPRODUCIBLE, .NON_REPRODUCIBLE:
                return false
        }
    }

    public func isReproducible() -> Bool {
        switch (self) {
            case .FULL_ASSERT, .NON_INTRUSIVE_FULL_ASSERT, .FAST_ASSERT, .REPRODUCIBLE:
                return true
            case .NON_REPRODUCIBLE:
                return false
        }
    }

}
