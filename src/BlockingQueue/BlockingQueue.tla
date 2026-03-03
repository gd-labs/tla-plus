--------------------------- MODULE BlockingQueue ---------------------------

EXTENDS Naturals, Sequences, FiniteSets

CONSTANTS Producers,
          Consumers,
          BufCapacity

ASSUME Assumption ==
  /\ Producers # {}
  /\ Consumers # {}
  /\ Producers \intersect Consumers = {}
  /\ BufCapacity \in (Nat \ {0})

----------------------------------------------------------------------------

VARIABLES buf, waitSet
vars == <<buf, waitSet>>

RunningThreads == (Producers \cup Consumers) \ waitSet

Notify == IF waitSet # {}
          THEN \E x \in waitSet: waitSet' = waitSet \ {x}
          ELSE UNCHANGED << waitSet >>

Wait(t) ==
  /\ waitSet' = waitSet \cup {t}
  /\ UNCHANGED << buf >>

----------------------------------------------------------------------------

Put(t, d) ==
  \/ /\ Len(buf) < BufCapacity
     /\ buf ' = Append(buf, d)
     /\ Notify
  \/ /\ buf # <<>>
     /\ Len(buf) = BufCapacity
     /\ Wait(t) 

Get(t) ==
  \/ /\ buf # <<>>
     /\ buf' = Tail(buf)
     /\ Notify
  \/ /\ buf = <<>>
     /\ Wait(t)

----------------------------------------------------------------------------

Init ==
  /\ buf = <<>>
  /\ waitSet = {}

Next == \E t \in RunningThreads:
  \/ /\ t \in Producers
     /\ Put(t, t)
  \/ /\ t \in Consumers
     /\ Get(t)

============================================================================
