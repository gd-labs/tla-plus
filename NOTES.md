# Notes

## Bounded and unbounded qunatifications

The quantification in the formulas `\forall x \in S : F` and `\exists x \in S : F` is said to be _bounded_, since these formulas make an assertion only about elements in the set `S`. There is also unbounded quantification. The formula `\forall x : F` asserts that `F` is true for all values `x`. and `\exists x : F` asserts that `F` is true for at least one value of `x`, a value that is not constrained to be in any particular set.

Whenever possible, it is better to use bounded than unbounded quantification in a specification. This makes the specification easier for both people and tools to understand.

## States and behaviors

A state is an assignment of values to variables and a behavior is an infinite sequence of states.

A formula such as [`HC`](./src/HourClock/HourClock.tla) is a temporal formula, which is defined as an assertion about behaviors. A behavior satisfies `HC` iff `HC` is a true assertion about the behavior

## Appendix

_state function_: ordinary expression that can contain variables and constants.

_state predicate_: Boolean-valued state function.

_invariant_: state predicate such that `Spec => []Inv` is a theorem, for a given specification `Spec` and an invariant `Inv`.

_type_: a variable `v` has type `T` in a specification `Spec` iff `v \in T` is an invariant of `Spec`.
