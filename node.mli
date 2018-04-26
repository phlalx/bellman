(* A node knows the total number of node in the system, as well as
   its direct neighbors. Upon creation, it is provided by the scheduler 
   with a [send] function that allows it to communicate to its neighbors
   via a *local address*.

   When calling [send], "0 <= local_id < num_neighbors" must hold.
   
   A typical implementation of this interface will set up the local process
   state in create, then [execute] reacts to local event by updating the
   local state and sending one or several messages using [send]. *)

type t

val create : num_nodes:int -> Global_id.t -> num_neighbors:int ->
  send: (Message.t * Local_id.t -> unit) -> t

val execute : t -> Levent.t -> unit
