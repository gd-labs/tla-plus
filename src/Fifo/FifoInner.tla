------------------------------ MODULE FifoInner ------------------------------

EXTENDS Naturals, Sequences

CONSTANT Message

VARIABLES in,
          out,
          q

InChan == INSTANCE Channel WITH Data <- Message, chan <- in

OutChan == INSTANCE Channel WITH Data <- Message, chan <- out

TypeInvariant ==
  /\ InChan!TypeInvariant
  /\ OutChan!TypeInvariant
  /\ q \in Seq(Message)

Init == 
  /\ InChan!Init
  /\ OutChan!Init
  /\ q = <<>>

(* Send `msg` on channel `in`. *)
SSend(msg) == 
  /\ InChan!Send(msg)
  /\ UNCHANGED << out, q >>

(* Receive message from channel `in` and append it to tail
   of `q`. *)
BufRecv ==
  /\ InChan!Recv
  /\ q' = Append(q, in.val)
  /\ UNCHANGED out

(* Enabled only if `q` is nonempty. Send `Head(q)` on channel
   `out` and remove it from `q`. *)
BufSend ==
  /\ q # << >>
  /\ OutChan!Send(Head(q))
  /\ q' = Tail(q)
  /\ UNCHANGED in

RRecv ==
  /\ OutChan!Recv
  /\ UNCHANGED << in, q >>

Next ==
  \/ \E msg \in Message : SSend(msg)
  \/ BufRecv
  \/ BufSend
  \/ RRecv

Spec == Init /\ [][Next]_<< in, out, q >>

------------------------------------------------------------------------------

THEOREM Spec => []TypeInvariant

==============================================================================
