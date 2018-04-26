open Core

(* application-level messages.  

   Messages exchanged between nodes. Specific to the distributed algorithm
   being simulated. In this message-passing version of Bellman-Ford. 
   Nodes send eachother their routing tables *)
  

type t = {
  id : Global_id.t;
  dist : int;
}

val to_string : t -> string