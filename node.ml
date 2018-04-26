(* Message-passing version of Bellman-ford algorithm. Each node 
   independently propagates its id through the network, allowing the 
   receiving nodes to update their routes to the initiating node *)

open Core

type t = { 
  global_id : Global_id.t;
  num_neighbors : int;
  send : Message.t * Local_id.t -> unit;
  routing : Routing.t
}

(* broadcast to all neighbors except lid *)
let broadcast_all_but t m lid =
  for i = 0 to t.num_neighbors - 1 do
    if not (i = lid) then
      t.send (m, i) 
  done

let broadcast t m = broadcast_all_but t m Local_id.dummy

let create ~num_nodes global_id ~num_neighbors ~send = 
  let routing = Routing.create num_nodes global_id in
  { global_id; num_neighbors; send; routing }

let execute t =
  function
  | Levent.Meta Mevent.Start -> broadcast t Message.{ id = t.global_id; dist = 0 }
  | Levent.Protocol ({Message.id; Message.dist}, lid) -> 
    let open Routing in
    if dist < t.routing.(id).dist - 1 then ( (* careful of int overflow *)
       t.routing.(id).dist <- dist + 1;
       t.routing.(id).route <- lid;
       broadcast_all_but t Message.{id; dist = dist + 1} lid;
       Printf.printf !"%{Global_id}: routes [%{Routing}]\n" t.global_id t.routing
    ) 