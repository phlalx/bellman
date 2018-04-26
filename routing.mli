open Core

type t

val create : num_nodes:int -> Global_id.t -> t

(* return true if table was updated *)
val update : t -> Local_id.t -> t -> bool

val to_string : t -> string
