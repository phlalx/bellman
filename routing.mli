open Core

type elt = { mutable dist : int; mutable route : Local_id.t } 

type t = elt Array.t

(* [create ~num_nodes gid] returns a routing table where no route is 
   known except the one from the caller (gid) to itself which has distance 0 *)
val create : num_nodes:int -> Global_id.t -> t

val to_string : t -> string
