--------------------------- MODULE CabbageWolfGoat ---------------------------
EXTENDS Integers, FiniteSets

CONSTANTS Cabbage,
          Goat,
          Man,
          Wolf

VARIABLES ferry_pos, bank_members

All == {Cabbage, Goat, Man, Wolf}

ASSUME Cardinality(All) = 4

TypeInvariant ==
  /\ ferry_pos \in {"L", "R"}
  /\ bank_members \in [{"L", "R"} -> SUBSET All]

OtherBank(b) == IF b = "L" THEN "R" ELSE "L"

Safe(Bank) ==
  /\ {Goat, Cabbage} \subseteq Bank => Man \in Bank
  /\ {Goat, Wolf} \subseteq Bank => Man \in Bank

Move(Members, b) ==
  /\ Cardinality(Members) = 2
  /\ Man \in Members
  /\ LET
      leftBank == bank_members[b] \ Members
      rightBank == bank_members[OtherBank(b)] \cup Members
     IN
      /\ Safe(leftBank)
      /\ Safe(rightBank)
      /\ ferry_pos' = OtherBank(b)
      /\ bank_members' =
          [pos \in {"L", "R"} |->
            IF pos = b THEN leftBank ELSE rightBank]

Init ==
  /\ ferry_pos = "L"
  /\ bank_members =
      [pos \in {"L", "R"} |->
        IF pos = "L"
        THEN All
        ELSE {}]

Next == \E Members \in SUBSET bank_members[ferry_pos] :
  Move(Members, ferry_pos)

Solution == bank_members["L"] /= {}

==============================================================================
