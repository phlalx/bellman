open Core

(* application-level messages.  

   Messages exchanged between nodes. Specific to the distributed algorithm
   being simulated. In this message-passing version of Bellman-Ford. 
   Nodes send to eachother their routing tables *)
   
type t = {
  routing : Routing.t;
}

val to_string : t -> string