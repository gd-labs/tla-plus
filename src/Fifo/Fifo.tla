--------------------------------- MODULE Fifo ---------------------------------

CONSTANT Message

VARIABLES in, out

Inner(q) == INSTANCE InnerFifo

Spec == \E q : Inner(q)!Spec

===============================================================================
