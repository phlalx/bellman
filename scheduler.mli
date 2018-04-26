open Core

type t

val create : num_nodes:int -> edges: (int * int) list -> t

val start_all_nodes : t -> unit

val schedule : t -> bool
