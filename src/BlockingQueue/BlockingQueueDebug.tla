------------------------- MODULE BlockingQueueDebug -------------------------

EXTENDS BlockingQueue,
        TLC,
        TLCExt

DelayedNext == TLCSet("pause", TRUE) /\ Next

NoDeadLock == PickSuccessor(waitSet' # (Producers \cup Consumers))

=============================================================================
