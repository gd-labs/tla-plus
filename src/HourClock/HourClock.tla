------------------------------ MODULE HourClock ------------------------------

EXTENDS Naturals

VARIABLE hr

(* Initial predicate that specifies the possible initial values
   of `hr`. Accepts any value from 1 through 12. *)
HCini == hr \in (1 .. 12)

(* Formula expressing the relation between the values of `hr`
   in the old state and new state of a step. *)
HCnxt == hr' = IF hr # 12 THEN hr + 1 ELSE 1

(* This formula must assert a behavior that
   
    1. Its initial state satisfies `HCini`, and
    2. Each of its steps satisfies `HCnxt`.

   To express 2, the temporal-logic operator _box_ is used. A
   temporal formula []F asserts that formula F is always true.
   The `[]HCnxt` formula is the assertion that `HCnxt` is true for
   every step in the behavior.

   By this reasoning, `HCini /\ []HCnxt` is true of a behavior
   iff the initial state satisfies `HCini` and every step satisfies
   `HCnxt`.

   Finally, with the above formula, there is no representation for
   unchanged `hr` values, or `hr' = hr` steps (stuttering steps).
   A formula that better represents steps must allow those that
   leave `hr` unchanged, such as `HCnxt \/ (hr' = hr)`. This
   suggests the following specification

    HCini /\ [](HCnxt \/ (hr' = hr))

   In TLA+, `[HCnxt]_hr` stands for `HCnxt \/ (hr' = hr)`. *)
HC == HCini /\ [][HCnxt]_hr

------------------------------------------------------------------------------

THEOREM HC => []HCini

==============================================================================
