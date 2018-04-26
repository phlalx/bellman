open Core

(* application-level messages.  

   Messages exchanged between nodes. Specific to the distributed algorithm
   begin simulated. Here, a variant of Bellman-Ford *)

type t = {
  id : Global_id.t;
  dist : int;
}

let to_string {id; dist} = Printf.sprintf !"[id = %{Global_id} dist = %d]" id dist