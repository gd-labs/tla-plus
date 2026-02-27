----------------------------- MODULE FifoBounded -----------------------------

EXTENDS Naturals, Sequences

VARIABLES in, out

CONSTANT Message, N

ASSUME (N \in Nat) /\ (N > 0)

Inner(q) == INSTANCE FifoInner

BNext(q) ==
  /\ Inner(q)!Next
  /\ Inner(q)!BufRecv => (Len(q) < N)

Spec == \E q : Inner(q)!Init /\ [][BNext(q)]_<< in, out, q >>

==============================================================================
