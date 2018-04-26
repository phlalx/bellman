open Core

(* application-level messages.  

   Messages exchanged between nodes. Specific to the distributed algorithm
   begin simulated. Here, a variant of Bellman-Ford *)

type t = {
  routing : Routing.t;
}

let to_string {routing} = Printf.sprintf !"[routing = [%{Routing}]]" routing