open Core

type t

(* [create ~num_nodes gid] returns a routing table where no route is 
   known except the one from the caller (gid) to itself which has distance 0 *)
val create : num_nodes:int -> Global_id.t -> t

(* [update t1 lid t2] updates table t1 with information from table t2 sent
  by neighbors lid. Returns true iff t1 was updated. t2 isn't modified *)
val update : t -> Local_id.t -> t -> bool

val to_string : t -> string
