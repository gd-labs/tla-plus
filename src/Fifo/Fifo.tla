--------------------------------- MODULE Fifo ---------------------------------

CONSTANT Message

VARIABLES in, out

Inner(q) == INSTANCE FifoInner

Spec == \E q : Inner(q)!Spec

===============================================================================
