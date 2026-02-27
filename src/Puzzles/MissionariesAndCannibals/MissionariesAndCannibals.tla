---------------------- MODULE MissionariesAndCannibals ----------------------

EXTENDS Integers, FiniteSets

CONSTANTS Cannibals,
          Missionaries

VARIABLES boat_pos, bank_members

TypeInvariant ==
  /\ boat_pos \in {"E", "W"}
  /\ bank_members \in [{"E", "W"} -> SUBSET (Cannibals \cup Missionaries)]

Init ==
  /\ boat_pos = "E"
  /\ bank_members =
      [pos \in {"E", "W"} |-> 
        IF pos = "E"
        THEN Cannibals \cup Missionaries
        ELSE {}]

IsSafe(Bank) ==
  \/ Bank \subseteq Cannibals
  \/ Cardinality(Bank \cap Missionaries) >= Cardinality(Bank \cap Cannibals)

OtherBank(Bank) == IF Bank = "E" THEN "W" ELSE "E"

Move(People, b) ==
  /\ Cardinality(People) \in {1, 2}
  /\ LET
      newThisBank == bank_members[b] \ People
      newOtherBank == bank_members[OtherBank(b)] \cup People
     IN
      /\ IsSafe(newThisBank)
      /\ IsSafe(newOtherBank)
      /\ boat_pos' = OtherBank(b)
      /\ bank_members' =
          [pos \in {"E", "W"} |->
            IF pos = b THEN newThisBank ELSE newOtherBank]

Next == \E People \in SUBSET bank_members[boat_pos] :
  Move(People, boat_pos)

Solution == bank_members["E"] /= {}

=============================================================================
