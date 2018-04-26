(* A node knows the total number of node in the system, as well as
   its direct neighbors. Upon creation, it is provided with a 
   [send] function that allows it to communicate to its neighbors
   via a *local address*. *)

type t

val create : num_nodes:int -> Global_id.t -> num_neighbors:int ->
  send: (Message.t * Local_id.t -> unit) -> t

val execute : t -> Levent.t -> unit
