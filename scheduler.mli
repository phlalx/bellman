(* 
The scheduler maintains a priority queue of [Gevent.t]. Messages are assigned
a (simulated) delivery time computed as "sending_time + x" where x is a random float  
between 0 and 1.  Nodes execution time is assumed to be 0. *)

open Core

type t

(* adjacency relation must be symmetric *)
val create : adjacency: Global_id.t Array.t Array.t -> t

val start_all_nodes : t -> unit

(* processes first event of the event queue and return true if the queue
   is empty *)
val schedule : t -> bool
