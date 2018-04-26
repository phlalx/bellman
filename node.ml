open Core

type t = { 
  global_id : Global_id.t;
  num_neighbors : int;
  send : Message.t * Local_id.t -> unit;
  routing : Routing.t
}

let broadcast t m =
  for i = 0 to t.num_neighbors - 1 do
    t.send (m, i) 
  done

let create ~num_nodes global_id ~num_neighbors ~send = 
  let routing = Routing.create num_nodes global_id in
  { global_id; num_neighbors; send; routing }

let broadcast_routing t =
    broadcast t Message.{routing = t.routing}  

let execute_meta t =
  function
  | Mevent.Start -> broadcast_routing t

let execute_msg t msg lid = 
  if Routing.update t.routing lid msg.Message.routing then (
    Printf.printf !"%{Global_id}: routing table updated -> [%{Routing}]\n" t.global_id t.routing;
    broadcast_routing t 
  ) 

let execute t =
  function
  | Levent.Meta meta -> execute_meta t meta
  | Levent.Protocol (m, lid) -> execute_msg t m lid